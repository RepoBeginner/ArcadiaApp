//
//  GBAButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 05/06/24.
//

import SwiftUI
import ArcadiaCore

struct GBAButtonLayout: View {
    var body: some View {
        HStack {
            CircleButtonView(arcadiaCoreButton: .joypadL, size: 50)
            Spacer()
            CircleButtonView(arcadiaCoreButton: .joypadSelect, size: 35)
            Spacer()
                .frame(width: 50)
            CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35)
            Spacer()
            CircleButtonView(arcadiaCoreButton: .joypadR, size: 50)
        }
        .padding()

        HStack {
            DPadView()
            Spacer()
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
    GBAButtonLayout()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}
