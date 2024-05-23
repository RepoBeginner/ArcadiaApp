//
//  PillShapedButtons.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct CapsuleButtonView: View {
    private var arcadiaCoreButton: ArcadiaCoreButton
    private var buttonText: String
    private var color: Color
    
    init(arcadiaCoreButton: ArcadiaCoreButton, buttonText: String, color: Color) {
        self.arcadiaCoreButton = arcadiaCoreButton
        self.buttonText = buttonText
        self.color = color
    }
    
    var body: some View {
        Button(action: {
            ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton)
        }) {
            ZStack {
                Capsule()
                    .fill(.gray
                        .shadow(.inner(color: .black, radius: 5))
                        .shadow(.drop(color: .black, radius: 10))
                
                    )
                    .frame(width: 50*1.5, height: 50)
                Text(buttonText)
                    .font(.headline)
                    .foregroundStyle(
                        Color.white
                            .shadow(.inner(color: .black, radius: 0.1, x: 0.3, y: 0.3))
                    )
            }
        }
    }
}

