//
//  ArrowButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 24/05/24.
//

import SwiftUI
import ArcadiaCore

struct ArrowButtonView: View {
    
    private var arcadiaCoreButton: ArcadiaCoreButton
    private var systemImageName: String
    
    init(arcadiaCoreButton: ArcadiaCoreButton) {
        self.arcadiaCoreButton = arcadiaCoreButton
        switch arcadiaCoreButton {
        case .joypadUp:
            self.systemImageName = "arrowtriangle.up.circle.fill"
        case .joypadDown:
            self.systemImageName = "arrowtriangle.down.circle.fill"
        case .joypadLeft:
            self.systemImageName = "arrowtriangle.left.circle.fill"
        case .joypadRight:
            self.systemImageName = "arrowtriangle.right.circle.fill"
        default:
            self.systemImageName = ""
        }
    }
    
    var body: some View {
        Button(action: {
            ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton)
        }) {
            Image(systemName: systemImageName)
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

#Preview {
    ArrowButtonView(arcadiaCoreButton: .joypadUp)
}
