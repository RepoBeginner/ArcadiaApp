//
//  TwoButtonsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 20/05/24.
//

import SwiftUI
import ArcadiaCore

struct TwoButtonsView: View {
    var body: some View {
        VStack(spacing: -5) {
                    //DPadButtonView(arcadiaCoreButton: .joypadUp, rotationAngle: 0)
            Spacer()
                .frame(width: 50, height: 50)
                    HStack(spacing: -0) {
                        Spacer()
                            .frame(width: 50, height: 50)
                        //DPadButtonView(arcadiaCoreButton: .joypadLeft, rotationAngle: 270)
                        Spacer()
                            .frame(width: 50, height: 50)
                        CircleButtonView(arcadiaCoreButton: .joypadA, size:50)
                        //DPadButtonView(arcadiaCoreButton: .joypadRight, rotationAngle: 90)
                    }
                    //DPadButtonView(arcadiaCoreButton: .joypadDown, rotationAngle: 180)
            CircleButtonView(arcadiaCoreButton: .joypadB, size:50)
                }
    }
}

#Preview {
    TwoButtonsView()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
    
}
