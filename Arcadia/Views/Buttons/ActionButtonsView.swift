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
    @AppStorage("actionPadButtonSpacing") private var actionPadButtonSpacing: Double = 5
    
    init(numberOfButtons: Int) {
        self.numberOfButtons = numberOfButtons
    }
    
    var body: some View {
        VStack(spacing: CGFloat(actionPadButtonSpacing)) {
            if numberOfButtons == 4 {
                CircleButtonView(arcadiaCoreButton: .joypadX, size:50*actionPadButtonScale)
            } else {
                EmptyButtonView(size: 50*actionPadButtonScale)
            }
                    HStack(spacing: CGFloat(actionPadButtonSpacing)) {
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
