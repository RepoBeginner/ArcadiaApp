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
    
    init(layoutElements: [ArcadiaButtonLayoutElements]) {
        self.layoutElements = layoutElements
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if layoutElements.contains(.start) {
                    CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35)
                }
                if layoutElements.contains(.backButtonsFirstRow) {
                    Spacer()
                    CircleButtonView(arcadiaCoreButton: .joypadR, size: 50)
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
    ArcadiaButtonLayoutRight(layoutElements: [])
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
