//
//  GBCButtonLayoutLeft.swift
//  Arcadia
//
//  Created by Davide Andreoli on 13/06/24.
//

import SwiftUI
import ArcadiaCore

struct GBCButtonLayoutLeft: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                CircleButtonView(arcadiaCoreButton: .joypadSelect, size: 35)
            }
            .padding()

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
    GBCButtonLayoutLeft()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}
