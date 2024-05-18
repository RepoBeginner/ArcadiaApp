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
                VStack {
                    DPadButtonView(arcadiaCoreButton: .joypadUp, rotationAngle: 0)
                    HStack {
                        DPadButtonView(arcadiaCoreButton: .joypadLeft, rotationAngle: 270)
                        Spacer()
                            .frame(maxWidth: 50)
                        DPadButtonView(arcadiaCoreButton: .joypadRight, rotationAngle: 90)
                    }
                    .padding(-10)
                    DPadButtonView(arcadiaCoreButton: .joypadDown, rotationAngle: 180)
                }
                

 
    }
}




/*
#Preview {
    JoypadView()
}
*/
