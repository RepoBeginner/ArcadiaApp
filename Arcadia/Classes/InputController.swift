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

@Observable class InputController {
    static let shared = InputController()
    
    var controllers: [GCController: UInt32] = [:]
    var availablePortIDs: [UInt32] = []
    var nextPortID: UInt32 = 0
    var mainInputPortID: UInt32 = 0
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidDisconnect), name: .GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery(completionHandler: nil)
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
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadA)
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
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadLeft)
            }
        }
        
        extendedGamepad.dpad.right.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadRight)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadRight)
            }
        }
        
        extendedGamepad.dpad.down.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadDown)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadDown)
            }
        }
        
        extendedGamepad.dpad.up.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: device, device: 1, index: 0, button: .joypadUp)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: device, device: 1, index: 0, button: .joypadUp)
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
}
