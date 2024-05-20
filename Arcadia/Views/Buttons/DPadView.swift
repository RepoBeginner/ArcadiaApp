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
        VStack(spacing: -15) {
                    DPadButtonView(arcadiaCoreButton: .joypadUp, rotationAngle: 0)
                    HStack(spacing: -15) {
                        DPadButtonView(arcadiaCoreButton: .joypadLeft, rotationAngle: 270)
                        Spacer()
                            .frame(width: 60, height: 60)
                        DPadButtonView(arcadiaCoreButton: .joypadRight, rotationAngle: 90)
                    }
                    DPadButtonView(arcadiaCoreButton: .joypadDown, rotationAngle: 180)
                }
        .frame(width: 200, height: 200)
                

 
    }
}






/*
#Preview {
    JoypadView()
}
*/
