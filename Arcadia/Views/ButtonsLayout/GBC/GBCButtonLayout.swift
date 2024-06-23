//
//  GBCButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 23/05/24.
//

import SwiftUI
import ArcadiaCore

struct GBCButtonLayout: View {
    var body: some View {
        HStack {
            CircleButtonView(arcadiaCoreButton: .joypadSelect, size: 35)
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
            TwoButtonsView()
        }
        .padding()

    }
}

#Preview {
    GBCButtonLayout()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
