//
//  CircleButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct CircleButtonView: View {
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
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            #endif
        }) {
            ZStack {
                Circle()
                    .fill(color
                        .shadow(.inner(color: .black, radius: 5))
                        .shadow(.drop(color: .black, radius: 10))
                    
                    )

                    .frame(width: 60, height: 60)
                Text(buttonText)
                    .font(.title)
                    .foregroundStyle(
                        Color.white
                            .shadow(.inner(color: .black, radius: 0.5, x: 0.5, y: 0.5))
                    )
            }
        }
    }
}

