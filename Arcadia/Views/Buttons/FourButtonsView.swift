//
//  FourButtonsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 27/06/24.
//

import SwiftUI
import ArcadiaCore

struct FourButtonsView: View {
    var body: some View {
        VStack(spacing: 5) {

            CircleButtonView(arcadiaCoreButton: .joypadX, size:50)
                    HStack {
                        CircleButtonView(arcadiaCoreButton: .joypadY, size:50)
                        Spacer()
                            .frame(width: 65, height: 50)
                        CircleButtonView(arcadiaCoreButton: .joypadA, size:50)
                    }
            CircleButtonView(arcadiaCoreButton: .joypadB, size:50)
                }
    }
}

#Preview {
    FourButtonsView()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
