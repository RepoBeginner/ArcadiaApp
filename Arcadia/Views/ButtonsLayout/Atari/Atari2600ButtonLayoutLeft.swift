//
//  Atari2600LayoutView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/07/24.
//

import SwiftUI
import ArcadiaCore

struct Atari2600ButtonLayoutLeft: View {
    var body: some View {
        VStack {
            Spacer()

            HStack {
                DPadView()
                VStack {
                    Spacer()
                        .frame(maxHeight: 100)
                    CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35)
                }
            }
            .padding()
        }
    }
}

#Preview {
    Atari2600ButtonLayoutLeft()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
