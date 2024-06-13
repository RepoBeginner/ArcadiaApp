//
//  GBAButtonLayoutRight.swift
//  Arcadia
//
//  Created by Davide Andreoli on 13/06/24.
//

import SwiftUI
import ArcadiaCore

struct GBAButtonLayoutRight: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35)
                Spacer()
                CircleButtonView(arcadiaCoreButton: .joypadR, size: 50)
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
    GBAButtonLayoutRight()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}
