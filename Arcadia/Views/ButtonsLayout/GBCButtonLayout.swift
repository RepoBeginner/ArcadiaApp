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
                .frame(width: 50)
            CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35)
        }

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
    GBCButtonLayout()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}
