//
//  GameGearButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 27/07/24.
//

import SwiftUI
import ArcadiaCore

struct GameGearButtonLayout: View {
    
    var body: some View {
        HStack {
            Spacer()
            CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35)
        }
        .padding()

        HStack {
            DPadView()
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35)
            }
            Spacer()
            ActionButtonsView(numberOfButtons: 2)
        }
        .padding()

    }
}

#Preview {
    GameGearButtonLayout()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
