//
//  SegaGenesisButtonLayoutRight.swift
//  Arcadia
//
//  Created by Davide Andreoli on 30/07/24.
//

import SwiftUI
import ArcadiaCore

struct SegaGenesisButtonLayoutRight: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35)
                Spacer()

            }
            .padding()

            HStack {
                ThreeButtonsView()
            }
            .padding()
        }

    }
}

#Preview {
    SegaGenesisButtonLayoutRight()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
