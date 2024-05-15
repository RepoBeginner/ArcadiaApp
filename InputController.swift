//
//  GameController.swift
//  Arcadia
//
//  Created by Davide Andreoli on 15/05/24.
//

import Foundation
import GameController

class InputController {
    static let shared = InputController()
    var keysPressed: Set<GCKeyCode> = []
    private init() {
        let center = NotificationCenter.default
        center.addObserver(
            forName: .GCKeyboardDidConnect,
            object: nil,
            queue: nil)
        { notification in
            let keyboard = notification.object as? GCKeyboard
            keyboard?.keyboardInput?.keyChangedHandler = { _, _, keyCode, pressed in
                if pressed {
                    self.keysPressed.insert(keyCode)
                } else {
                    self.keysPressed.remove(keyCode)
                }
            }
        }
        
    #if os(macOS)
    NSEvent.addLocalMonitorForEvents(matching: [.keyUp, .keyDown]) { _ in nil }
    #endif
    }
}
