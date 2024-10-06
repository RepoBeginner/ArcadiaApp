//
//  ActionButtonsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 06/08/24.
//

import SwiftUI
import ArcadiaCore

struct ActionButtonsView: View {
    
    private var numberOfButtons: Int
    @AppStorage("actionPadButtonScale") private var actionPadButtonScale: Double = 1
    
    init(numberOfButtons: Int) {
        self.numberOfButtons = numberOfButtons
    }
    
    var body: some View {
        VStack(spacing: 5) {
            if numberOfButtons == 4 {
                CircleButtonView(arcadiaCoreButton: .joypadX, size:50*actionPadButtonScale)
            } else {
                EmptyButtonView(size: 50*actionPadButtonScale)
            }
                    HStack {
                        if numberOfButtons >= 3 {
                            CircleButtonView(arcadiaCoreButton: .joypadY, size:50*actionPadButtonScale)
                        } else {
                            EmptyButtonView(size: 50*actionPadButtonScale)
                        }
                        EmptyButtonView(size: 50*actionPadButtonScale)
                        if numberOfButtons >= 2 {
                            CircleButtonView(arcadiaCoreButton: .joypadA, size:50*actionPadButtonScale)
                        } else {
                            EmptyButtonView(size: 50*actionPadButtonScale)
                        }
                        
                    }
            CircleButtonView(arcadiaCoreButton: .joypadB, size:50*actionPadButtonScale)
                }
    }
}

#Preview {
    ActionButtonsView(numberOfButtons: 4)
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
