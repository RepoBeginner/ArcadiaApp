//
//  GBCButtonLayoutRight.swift
//  Arcadia
//
//  Created by Davide Andreoli on 13/06/24.
//

import SwiftUI
import ArcadiaCore

struct GBCButtonLayoutRight: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35)
                Spacer()

            }
            .padding()

            HStack {
                TwoButtonsView()
            }
            .padding()
        }

    }
}

#Preview {
    GBCButtonLayoutRight()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}
