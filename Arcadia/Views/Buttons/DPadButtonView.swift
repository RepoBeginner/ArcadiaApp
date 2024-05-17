//
//  JoypadButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct DPadButtonView: View {
    
    @State private var core: any ArcadiaCoreProtocol
    private var arcadiaCoreButton: ArcadiaCoreButton
    private var rotationAngle: Double
    
    init(core: any ArcadiaCoreProtocol, arcadiaCoreButton: ArcadiaCoreButton, rotationAngle: Double) {
        self.core = core
        self.arcadiaCoreButton = arcadiaCoreButton
        self.rotationAngle = rotationAngle
    }
    
    var body: some View {
        Button(action: {
            core.pressButton(button: arcadiaCoreButton)
        }) {
            Trapezoid()
                .fill(Color.red)
                .frame(width: 30, height: 30*1.5)
                .rotationEffect(Angle(degrees: rotationAngle))
        }
    }
}

