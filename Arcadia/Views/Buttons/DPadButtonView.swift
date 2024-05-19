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
            ArcadiaCoreEmulationState.sharedInstance.pressButton(button: arcadiaCoreButton)
        }) {

                ZStack {
                    Trapezoid()
                        .stroke(.orange, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .fill(Color.red)
                        .padding(5)
                        .rotationEffect(Angle(degrees: rotationAngle))
                        
                }
                .frame(width: 60, height: 60)
            
                
        }
    }
}

