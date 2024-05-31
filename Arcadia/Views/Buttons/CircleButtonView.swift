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
                        ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton.rawValue)
                    } else {
                        
                    }
                })
                .onEnded({ _ in
                    if arcadiaCoreButton != .arcadiaButton {
                        ArcadiaCoreEmulationState.sharedInstance.unpressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton.rawValue)
                    } else {
                        ArcadiaCoreEmulationState.sharedInstance.pauseEmulation()
                        ArcadiaCoreEmulationState.sharedInstance.showOverlay.toggle()
                    }
                })
        )

                

                       
    }
}

#Preview {
    CircleButtonView(arcadiaCoreButton: .joypadA)
}

