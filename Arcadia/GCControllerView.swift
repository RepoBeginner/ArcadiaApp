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

struct GCVirtualControllerView: UIViewRepresentable {
    class Coordinator: NSObject {
        var virtualController: GCVirtualController?
        
        func setupVirtualController() {
            

            let configuration = GCVirtualController.Configuration()
            configuration.elements = [GCInputDirectionPad, GCInputButtonA, GCInputButtonB]
            
            
            virtualController = GCVirtualController(configuration: configuration)
            
            virtualController?.connect { error in
                if let error = error {
                    print("Failed to connect virtual controller: \(error.localizedDescription)")
                } else {
                    print("Virtual controller connected successfully.")
                }
            }
            
            virtualController?.controller?.extendedGamepad?.valueChangedHandler = { gamepad, element in
                // Handle gamepad input here
                print("Gamepad value changed: \(element)")
            }
        }
        
        func disconnectVirtualController() {
            virtualController?.disconnect()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
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
}
#endif
