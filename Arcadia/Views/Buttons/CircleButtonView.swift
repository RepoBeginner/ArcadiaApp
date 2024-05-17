//
//  CircleButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct CircleButtonView: View {
    @State private var core: any ArcadiaCoreProtocol
    private var arcadiaCoreButton: ArcadiaCoreButton
    private var buttonText: String
    private var color: Color
    
    init(core: any ArcadiaCoreProtocol, arcadiaCoreButton: ArcadiaCoreButton, buttonText: String, color: Color) {
        self.core = core
        self.arcadiaCoreButton = arcadiaCoreButton
        self.buttonText = buttonText
        self.color = color
    }
    
    var body: some View {
        Button(action: {
            core.pressButton(button: arcadiaCoreButton)
        }) {
            ZStack {
                Circle()
                    .fill(color)
                Text(buttonText)
            }
        }
    }
}

