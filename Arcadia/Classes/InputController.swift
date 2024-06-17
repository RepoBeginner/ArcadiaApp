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
    
    var controllers: [GCController: UInt32] = [:]
    var availablePortIDs: [UInt32] = []
    var nextPortID: UInt32 = 0
    var mainInputPortID: UInt32 = 0
    var gameKeyboardMapping: [ArcadiaCoreButton : GCKeyCode] =  [
        .joypadB : .keyB,
        .joypadY : .keyY,
        .joypadSelect : .returnOrEnter,
        .joypadStart : .leftControl,
        .joypadUp: .upArrow,
        .joypadDown: .downArrow,
        .joypadLeft: .leftArrow,
        .joypadRight: .rightArrow,
        .joypadA : .keyA,
        .joypadX : .keyX,
        .joypadL : .one,
        .joypadR : .four,
        .joypadL2 : .two,
        .joypadR2 : .five,
        .joypadL3 : .three,
        .joypadR3 : .six,
    ]
    var keyboardIsConnected: Bool {
        if let keyboard = GCKeyboard.coalesced?.keyboardInput {
            return true
        } else {
            return false
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidDisconnect), name: .GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery(completionHandler: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidConnect), name: .GCKeyboardDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidDisconnect), name: .GCKeyboardDidDisconnect, object: nil)
        
        loadGameKeyMappings()
        if let keyboard = GCKeyboard.coalesced?.keyboardInput {
            setupKeyboard(keyboard)
        }
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
        }
    }
    
    @objc private func keyboardDidConnect(notification: Notification) {
        if let keyboard = notification.object as? GCKeyboard {
            setupKeyboard(keyboard.keyboardInput)
        }
    }
    
    @objc private func keyboardDidDisconnect(notification: Notification) {
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

