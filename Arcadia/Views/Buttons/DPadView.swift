//
//  ArrowButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct DPadView: View {
    
    var body: some View {
        VStack(spacing: -5) {
                    //DPadButtonView(arcadiaCoreButton: .joypadUp, rotationAngle: 0)
            CircleButtonView(arcadiaCoreButton: .joypadUp, size:50)
                    HStack(spacing: -0) {
                        CircleButtonView(arcadiaCoreButton: .joypadLeft, size:50)
                        //DPadButtonView(arcadiaCoreButton: .joypadLeft, rotationAngle: 270)
                        Spacer()
                            .frame(width: 50, height: 50)
                        CircleButtonView(arcadiaCoreButton: .joypadRight, size:50)
                        //DPadButtonView(arcadiaCoreButton: .joypadRight, rotationAngle: 90)
                    }
                    //DPadButtonView(arcadiaCoreButton: .joypadDown, rotationAngle: 180)
            CircleButtonView(arcadiaCoreButton: .joypadDown, size:50)
                }
 
    }
}

#Preview {
    DPadView()
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}

