//
//  ArcadiaButtonLayoutRight.swift
//  Arcadia
//
//  Created by Davide Andreoli on 06/08/24.
//

import SwiftUI
import ArcadiaCore

struct ArcadiaButtonLayoutRight: View {
    
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
                if layoutElements.contains(.start) {
                    CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35*smallButtonScale)
                }
                if layoutElements.contains(.backButtonsFirstRow) {
                    Spacer()
                    CircleButtonView(arcadiaCoreButton: .joypadR, height: 40*shoulderButtonScale, width: 70*shoulderButtonScale)
                }
                
            }
            .padding()
            HStack {
                if layoutElements.contains(.oneActionButton) {
                    ActionButtonsView(numberOfButtons: 1)
                } else if layoutElements.contains(.twoActionButtons) {
                    ActionButtonsView(numberOfButtons: 2)
                } else if layoutElements.contains(.threeActionButtons) {
                    ActionButtonsView(numberOfButtons: 3)
                } else if layoutElements.contains(.fourActionButtons) {
                    ActionButtonsView(numberOfButtons: 4)
                }
            }
            .padding()
        }

    }
}

#Preview {
    ArcadiaButtonLayoutRight(layoutElements: [.backButtonsFirstRow])
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
