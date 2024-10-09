//
//  GameController.swift
//  Arcadia
//
//  Created by Davide Andreoli on 15/05/24.
//

import Foundation
import GameController
import SwiftUI
import ArcadiaCore
import Combine
import CoreHaptics

enum MenuMovementAction {
    case moveUp
    case moveDown
    case moveLeft
    case moveRight
    case enter
}

@Observable class InputController {
    static let shared = InputController()
    
    var action: MenuMovementAction?
    
    var vibrationNotificationSubscription: AnyCancellable?
    var controllers: [GCController: UInt32] = [:]
    var controllersHapticsEngines: [GCController: CHHapticEngine] = [:]
    var availablePortIDs: [UInt32] = []
    var nextPortID: UInt32 = 0
    var mainInputPortID: UInt32 = 0
    var gameKeyboardMapping: [ArcadiaCoreButton : GCKeyCode] =  [
        .joypadB : .keyZ,
        .joypadY : .keyA,
        .joypadSelect : .leftShift,
        .joypadStart : .returnOrEnter,
        .joypadUp: .upArrow,
        .joypadDown: .downArrow,
        .joypadLeft: .leftArrow,
        .joypadRight: .rightArrow,
        .joypadA : .keyX,
        .joypadX : .keyS,
        .joypadL : .keyQ,
        .joypadR : .keyW,
        .joypadL2 : .keyE,
        .joypadR2 : .keyR,
        .joypadL3 : .keyT,
        .joypadR3 : .keyY,
    ]
    var keyboardIsConnected: Bool {
        if let keyboard = GCKeyboard.coalesced?.keyboardInput {
            return true
        } else {
            return false
        }
    }
    
    init() {
        //TODO: Update these to use the same mechanism as vibrationNotificationSubscription
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidDisconnect), name: .GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery(completionHandler: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidConnect), name: .GCKeyboardDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisconnect), name: .GCKeyboardDidDisconnect, object: nil)
        
        self.vibrationNotificationSubscription = NotificationCenter.default
            .publisher(for: .arcadiaVibrationNotification)
            .map( { ($0.object as! ArcadiaVibrationNotification) } )
            .sink(receiveCompletion: {
                completion in
                print(completion)
            }, receiveValue: {
                value in
                if let hapticFeedbackEnabled = UserDefaults.standard.object(forKey: "hapticFeedback") as? Bool {
                    if hapticFeedbackEnabled {
                        self.handleVibration(notification: value)
                    }
                }
            })
        
        loadGameKeyMappings()
        if let keyboard = GCKeyboard.coalesced?.keyboardInput {
            setupKeyboard(keyboard)
        }
    }
    
    deinit {
        vibrationNotificationSubscription?.cancel()
    }
    
    @objc private func controllerDidConnect(notification: Notification) {
        if let controller = notification.object as? GCController {
            let portID: UInt32
            if availablePortIDs.isEmpty {
                portID = nextPortID
                nextPortID += 1
            } else {
                portID = availablePortIDs.removeFirst()
            }
            controllers[controller] = portID
            setupController(controller: controller, device: portID)
        }
    }
    
    @objc private func controllerDidDisconnect(notification: Notification) {
        if let disconnectedController = notification.object as? GCController {
            if let deviceID = controllers[disconnectedController] {
                controllers.removeValue(forKey: disconnectedController)
                availablePortIDs.append(deviceID)
            }
            
            if controllersHapticsEngines[disconnectedController] != nil {
                controllersHapticsEngines.removeValue(forKey: disconnectedController)
            }
        }
    }
    
    @objc private func keyboardDidConnect(notification: Notification) {
        if let keyboard = notification.object as? GCKeyboard {
            setupKeyboard(keyboard.keyboardInput)
        }
    }
    
    @objc private func keyboardDidDisconnect(notification: Notification) {
    }
    
    public func handleVibration(notification: ArcadiaVibrationNotification) {
        #if os(iOS)
        if notification.port == self.mainInputPortID && !controllers.values.contains(notification.port) {
            if notification.effect.rawValue == 0 {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            } else {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
        #endif
        for controller in controllers.keys {
            if controllers[controller] == notification.port {
                if let engine = getOrCreateHapticEngine(for: controller) {
                    do {
                        try engine.start()

                        // Create a basic haptic event for vibration
                        var intensityValue: Float = 0.3
                        if notification.effect.rawValue == 0 {
                            intensityValue = 0.8
                        } else {
                            intensityValue = 0.3
                        }
                        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue)
                        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)

                        // Create a pattern from the event
                        let pattern = try CHHapticPattern(events: [event], parameters: [])

                        // Create a player for the pattern and start it
                        let player = try engine.makePlayer(with: pattern)
                        try player.start(atTime: 0)
                        // Stop the engine after the vibration
                        engine.notifyWhenPlayersFinished { _ in
                            engine.stop()
                            return .stopEngine
                        }
                    } catch {
                        print("Failed to create haptic engine or play pattern: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getOrCreateHapticEngine(for controller: GCController) -> CHHapticEngine? {
        // Check if the engine already exists for this controller
        if let engine = controllersHapticsEngines[controller] {
            return engine
        }
        
        if let haptics = controller.haptics {
            if let engine = haptics.createEngine(withLocality: .default) {
                controllersHapticsEngines[controller] = engine
                return engine
            }
        }
        return nil
    }
    
    public func updateControllerConfiguration(controller: GCController, from originPort: UInt32?, to destinationPort: UInt32?) {
        guard let destinationPort = destinationPort, let originPort = originPort else {
            return
        }
        if !availablePortIDs.contains(originPort) && !controllers.values.contains(originPort) && nextPortID > originPort {
            availablePortIDs.append(originPort)
        } else if availablePortIDs.contains(destinationPort) {
            availablePortIDs.removeAll(where: { element in element == destinationPort })
        }
        setupController(controller: controller, device: destinationPort)
    }
    
    private func setupController(controller: GCController, device: UInt32) {
        guard let extendedGamepad = controller.extendedGamepad else { return }
        
        extendedGamepad.buttonA.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadA)
                self.action = .enter
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadA)
                self.action = nil
            }
        }
        
        extendedGamepad.buttonB.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadB)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadB)
            }
        }
        
        extendedGamepad.buttonX.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadX)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadX)
            }
        }
        
        extendedGamepad.buttonY.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadY)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadY)
            }
        }
        
        extendedGamepad.dpad.left.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadLeft)
                self.action = .moveLeft
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadLeft)
                self.action = nil
            }
        }
        
        extendedGamepad.dpad.right.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadRight)
                self.action = .moveRight
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadRight)
                self.action = nil
            }
        }
        
        extendedGamepad.dpad.down.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadDown)
                self.action = .moveDown
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadDown)
                self.action = nil
            }
        }
        
        extendedGamepad.dpad.up.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadUp)
                self.action = .moveUp
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadUp)
                self.action = nil
            }
        }
        
        extendedGamepad.leftShoulder.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadL)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadL)
            }
        }
        
        extendedGamepad.leftTrigger.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadL2)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadL2)
            }
        }
        
        extendedGamepad.rightShoulder.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadR)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadR)
            }
        }
        
        extendedGamepad.rightTrigger.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadR2)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadR2)
            }
        }
        
        extendedGamepad.buttonOptions?.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadSelect)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadSelect)
            }
        }
        
        extendedGamepad.buttonMenu.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadStart)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadStart)
            }
        }
        
        extendedGamepad.buttonHome?.pressedChangedHandler = { button, value, pressed in
            ArcadiaCoreEmulationState.sharedInstance.showOverlay.toggle()
        }
    }
    
    
    private func setupKeyboard(_ keyboard: GCKeyboardInput?) {
        guard let keyboard = keyboard else { return }
        
        for (arcadiaButton ,keyCode) in gameKeyboardMapping {
            keyboard.button(forKeyCode: keyCode)?.pressedChangedHandler = { button, value, pressed in
                if pressed {
                    ArcadiaCoreEmulationState.sharedInstance.pressButton(port: self.mainInputPortID, device: 1, index: 0, button: arcadiaButton)
                } else {
                    ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: self.mainInputPortID, device: 1, index: 0, button: arcadiaButton)
                }
            }
        }
    }
    
    public func updateKeyboardMapping() {
            saveGameKeyMappings()
    }
    
    private func saveGameKeyMappings() {
        let mappings = gameKeyboardMapping.map { (key, value) in
            return ["key": key.rawValue, "action": value.rawValue]
        }
        UserDefaults.standard.set(mappings, forKey: "keyMappings")
    }
    
    private func loadGameKeyMappings() {
        if let mappings = UserDefaults.standard.array(forKey: "keyMappings") as? [[String: Int]] {
            for mapping in mappings {
                guard let arcadiaKey = mapping["key"], let key = mapping["action"] else {
                    break
                }
                let keyCode = GCKeyCode(rawValue: key)
                guard let arcadiaButton = ArcadiaCoreButton(rawValue: UInt32(arcadiaKey)) else {
                    break
                }
                gameKeyboardMapping[arcadiaButton] = keyCode
            }
        }
    }
    
    public func loadGameConfiguration() {
        for controller in controllers.keys {
            setupController(controller: controller, device: controllers[controller]!)
        }
        if let keyboard = GCKeyboard.coalesced?.keyboardInput {
            setupKeyboard(keyboard)
        }
    }
    
    public func unloadGameConfiguration() {
        for controller in controllers.keys {
            controller.extendedGamepad?.valueChangedHandler = nil
        }
        if let keyboard = GCKeyboard.coalesced?.keyboardInput {
            keyboard.valueDidChangeHandler = nil
        }
    }
    
}

