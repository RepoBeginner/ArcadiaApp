//
//  Atari2600LayoutRight.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/07/24.
//

import SwiftUI
import ArcadiaCore

struct Atari2600ButtonLayoutRight: View {
    var body: some View {
        VStack {
            Spacer()
            .padding()

            HStack {
                BButtonView()
            }
            .padding()
        }
    }
}

#Preview {
    Atari2600ButtonLayoutRight()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
