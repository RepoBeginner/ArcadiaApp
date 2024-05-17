//
//  ArrowButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct DPadView: View {
    @State private var core: any ArcadiaCoreProtocol
    
    init(core: any ArcadiaCoreProtocol) {
        self.core = core
    }
    
    var body: some View {
                VStack {
                    DPadButtonView(core: core, arcadiaCoreButton: .joypadUp, rotationAngle: 0)
                    HStack {
                        DPadButtonView(core: core, arcadiaCoreButton: .joypadLeft, rotationAngle: 270)
                        Spacer()
                            .frame(maxWidth: 50)
                        DPadButtonView(core: core, arcadiaCoreButton: .joypadRight, rotationAngle: 90)
                    }
                    .padding(-10)
                    DPadButtonView(core: core, arcadiaCoreButton: .joypadDown, rotationAngle: 180)
                }
                

 
    }
}




/*
#Preview {
    JoypadView()
}
*/
