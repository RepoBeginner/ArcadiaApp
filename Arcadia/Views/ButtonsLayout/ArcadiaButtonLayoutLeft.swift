//
//  ArcadiaButtonLayoutLeft.swift
//  Arcadia
//
//  Created by Davide Andreoli on 06/08/24.
//

import SwiftUI
import ArcadiaCore

struct ArcadiaButtonLayoutLeft: View {
    
    private var layoutElements: [ArcadiaButtonLayoutElements]
    @AppStorage("smallButtonScale") private var smallButtonScale: Double = 1
    @AppStorage("shoulderButtonScale") private var shoulderButtonScale: Double = 1
    
    init(layoutElements: [ArcadiaButtonLayoutElements]) {
        self.layoutElements = layoutElements
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if layoutElements.contains(.backButtonsFirstRow) {
                    CircleButtonView(arcadiaCoreButton: .joypadL, height: 40*shoulderButtonScale, width: 70*shoulderButtonScale)
                    Spacer()
                }
                if layoutElements.contains(.select) {
                    CircleButtonView(arcadiaCoreButton: .joypadSelect, size: 35*smallButtonScale)
                }
            }
            .padding()

            HStack {
                if layoutElements.contains(.dPad) {
                    DPadView()
                }
                
                Spacer()
                VStack {
                    Spacer()
                        .frame(maxHeight: 100)
                    CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35*smallButtonScale)
                }
            }
            .padding()
        }

    }
}

#Preview {
    ArcadiaButtonLayoutLeft(layoutElements: [])
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
