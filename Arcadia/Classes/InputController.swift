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
    
    var controller: GCController?
    var pressHandlers: [UInt32 : [UInt32 : [UInt32 : [UInt32 : Int16]]]] = [:]
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidConnect), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(controllerDidDisconnect), name: .GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery(completionHandler: nil)
    }
    
    @objc private func controllerDidConnect(notification: Notification) {
        controller = notification.object as? GCController
        setupController(controller: controller)
    }
    
    @objc private func controllerDidDisconnect(notification: Notification) {
        if let disconnectedController = notification.object as? GCController, disconnectedController == controller {
            controller = nil
        }
    }
    
    private func setupController(controller: GCController?) {
        guard let extendedGamepad = controller?.extendedGamepad else { return }
        
        extendedGamepad.buttonA.pressedChangedHandler = { button, value, pressed in

            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadA)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadA)
            }
        }
        
        extendedGamepad.buttonB.pressedChangedHandler = { button, value, pressed in

            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadB)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadB)
            }
        }
        extendedGamepad.buttonX.pressedChangedHandler = { button, value, pressed in

            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadX)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadX)
            }
        }
        extendedGamepad.buttonY.pressedChangedHandler = { button, value, pressed in

            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadY)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadY)
            }
        }
                
        extendedGamepad.dpad.left.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadLeft)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadLeft)
            }
        }
        
        extendedGamepad.dpad.right.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadRight)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadRight)
            }
        }
        
        extendedGamepad.dpad.down.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadDown)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadDown)
            }
        }
        
        extendedGamepad.dpad.up.pressedChangedHandler = { button, value, pressed in
            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadUp)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadUp)
            }
        }
        
        extendedGamepad.buttonOptions?.pressedChangedHandler = { button, value, pressed in

            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadSelect)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadSelect)
            }
        }
        
        extendedGamepad.buttonMenu.pressedChangedHandler = { button, value, pressed in

            if pressed {
                ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadStart)
            } else {
                ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: .joypadStart)
            }
        }
        
        extendedGamepad.buttonHome?.pressedChangedHandler = { button, value, pressed in
            ArcadiaCoreEmulationState.sharedInstance.showOverlay.toggle()
        }
    }
    

    

}
