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
    private var color: Color
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState

    
    init(arcadiaCoreButton: ArcadiaCoreButton, color: Color = .gray) {
        self.arcadiaCoreButton = arcadiaCoreButton
        self.color = color
    }
    
    var body: some View {
        
        Button(action: {
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        }) {
            Image(systemName: arcadiaCoreButton.systemImageName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.primary)

        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    if arcadiaCoreButton != .arcadiaButton {
                        emulationState.pressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton.rawValue)
                    } else {
                        
                    }
                })
                .onEnded({ _ in
                    if arcadiaCoreButton != .arcadiaButton {
                        emulationState.unpressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton.rawValue)
                    } else {
                        emulationState.pauseEmulation()
                        emulationState.showOverlay.toggle()
                    }
                })
        )

                

                       
    }
}

#Preview {
    CircleButtonView(arcadiaCoreButton: .joypadA)
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}

