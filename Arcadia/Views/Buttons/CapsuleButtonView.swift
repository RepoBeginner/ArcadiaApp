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
            ArcadiaCoreEmulationState.sharedInstance.pressButton(button: arcadiaCoreButton)
        }) {
            ZStack {
                Capsule()
                    .fill(color)
                    .frame(width: 50*1.5, height: 50)
                Text(buttonText)
            }
        }
    }
}

