//
//  Atari7800ButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 18/07/24.
//

import SwiftUI
import ArcadiaCore

struct Atari7800ButtonLayout: View {
    var body: some View {
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
    Atari7800ButtonLayout()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
