//
//  Atari2600Layout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/07/24.
//

import SwiftUI
import ArcadiaCore

struct Atari2600ButtonLayout: View {
    var body: some View {
        HStack {
            DPadView()
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35)
            }
            Spacer()
            BButtonView()
        }
        .padding()

    }
}

#Preview {
    Atari2600ButtonLayout()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
