//
//  GCControllerView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 23/05/24.
//

#if os(iOS)
import Foundation
import SwiftUI
import GameController
import UIKit
import ArcadiaCore

struct GCVirtualControllerView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        context.coordinator.setupVirtualController()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed
    }
    
    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        coordinator.disconnectVirtualController()
    }
    
    class Coordinator: NSObject {
        var parent: GCVirtualControllerView
        var virtualController: GCVirtualController?
        
        init(_ parent: GCVirtualControllerView, virtualController: GCVirtualController? = nil) {
            self.parent = parent
            self.virtualController = virtualController
        }
        
        func setupVirtualController() {
            
            let configuration = GCVirtualController.Configuration()
            configuration.elements = [GCInputButtonA, GCInputButtonB, GCInputDirectionPad]
            
            
            virtualController = GCVirtualController(configuration: configuration)
            
            virtualController?.connect { error in
                if let error = error {
                    print("Failed to connect virtual controller: \(error.localizedDescription)")
                } else {
                    print("Virtual controller connected successfully.")
                }
            }
            
            virtualController?.controller?.extendedGamepad?.dpad.valueChangedHandler = { dpad, xValue, yValue in
                      print("DPad value changed: x=\(xValue), y=\(yValue)")
                      // Handle DPad input here
                  }
            
            virtualController?.controller?.extendedGamepad?.buttonA.pressedChangedHandler = {
                button, value, pressed in
                if pressed {
                    ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadA)
                }
            }
            
            virtualController?.controller?.extendedGamepad?.buttonB.pressedChangedHandler = {
                button, value, pressed in
                if pressed {
                    ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: .joypadB)
                }
            }
        }
        
        func disconnectVirtualController() {
            virtualController?.disconnect()
        }
    }
}
#endif
