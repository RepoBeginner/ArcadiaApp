//
//  ThreeButtonsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 30/07/24.
//

import SwiftUI
import ArcadiaCore

struct ThreeButtonsView: View {
    var body: some View {
        VStack(spacing: 5) {

            HStack {
                Spacer()
                    .frame(width: 50, height: 50)

                Spacer()
                    .frame(width: 150, height: 50)
                CircleButtonView(arcadiaCoreButton: .joypadA, size:50)

            }
                    HStack {
                        Spacer()
                            .frame(width: 50, height: 50)

                        Spacer()
                            .frame(width: 50, height: 50)
                        CircleButtonView(arcadiaCoreButton: .joypadB, size:50)

                    }
            CircleButtonView(arcadiaCoreButton: .joypadY, size:50)
                }
    }
}

#Preview {
    ThreeButtonsView()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
