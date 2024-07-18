//
//  Atari7800ButtonLayoutRight.swift
//  Arcadia
//
//  Created by Davide Andreoli on 18/07/24.
//

import SwiftUI
import ArcadiaCore

struct Atari7800ButtonLayoutRight: View {
    var body: some View {
        VStack {
            Spacer()
            .padding()

            HStack {
                TwoButtonsView()
            }
            .padding()
        }
    }
}

#Preview {
    Atari7800ButtonLayoutRight()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
