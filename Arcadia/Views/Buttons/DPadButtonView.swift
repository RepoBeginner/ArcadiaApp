//
//  JoypadButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct DPadButtonView: View {
    
    private var arcadiaCoreButton: ArcadiaCoreButton
    private var rotationAngle: Double
    
    init(arcadiaCoreButton: ArcadiaCoreButton, rotationAngle: Double) {
        self.arcadiaCoreButton = arcadiaCoreButton
        self.rotationAngle = rotationAngle
    }
    
    var body: some View {
        Button(action: {
            ArcadiaCoreEmulationState.sharedInstance.pressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton)
        }) {


             ZStack {
                 Trapezoid()
                     .fill(.gray
                         .shadow(.inner(color: .black, radius: 5))
                         .shadow(.drop(color: .black, radius: 10))
                 
                     )
                     .padding(5)
                     .rotationEffect(Angle(degrees: rotationAngle))
                     
             }
             .frame(width: 60, height: 70)

            
                
        }
        .buttonRepeatBehavior(.enabled)
    }
}

#Preview {
    DPadButtonView(arcadiaCoreButton: .joypadA, rotationAngle: 90)
}

