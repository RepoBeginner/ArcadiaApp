//
//  SegaGenesisButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 30/07/24.
//

import SwiftUI
import ArcadiaCore

struct SegaGenesisButtonLayout: View {
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
            ThreeButtonsView()
        }
        .padding()

    }
}

#Preview {
    SegaGenesisButtonLayout()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
