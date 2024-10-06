//
//  ArcadiaButtonLayout.swift
//  Arcadia
//
//  Created by Davide Andreoli on 06/08/24.
//

import SwiftUI
import ArcadiaCore

enum ArcadiaButtonLayoutElements {
    case start
    case select
    case dPad
    case backButtonsFirstRow
    case oneActionButton
    case twoActionButtons
    case threeActionButtons
    case fourActionButtons
}

struct ArcadiaButtonLayout: View {
    
    private var layoutElements: [ArcadiaButtonLayoutElements]
    @AppStorage("smallButtonScale") private var smallButtonScale: Double = 1
    @AppStorage("shoulderButtonScale") private var shoulderButtonScale: Double = 1
    
    init(layoutElements: [ArcadiaButtonLayoutElements]) {
        self.layoutElements = layoutElements
    }
    
    var body: some View {
        HStack {
            if layoutElements.contains(.backButtonsFirstRow) {
                CircleButtonView(arcadiaCoreButton: .joypadL, height: 40*shoulderButtonScale, width: 70*shoulderButtonScale)
                Spacer()
                    .frame(width: 50)
            }
            if layoutElements.contains(.select) {
                CircleButtonView(arcadiaCoreButton: .joypadSelect, size: 35*smallButtonScale)
            }
            Spacer()
            if layoutElements.contains(.start) {
                CircleButtonView(arcadiaCoreButton: .joypadStart, size: 35*smallButtonScale)
            }
            if layoutElements.contains(.backButtonsFirstRow) {
                Spacer()
                    .frame(width: 50)
                CircleButtonView(arcadiaCoreButton: .joypadR, height: 40*shoulderButtonScale, width: 70*shoulderButtonScale)
            }
        }
        .padding()

        HStack {
            if layoutElements.contains(.dPad) {
                DPadView()
            }
            VStack {
                Spacer()
                    .frame(maxHeight: 100)
                CircleButtonView(arcadiaCoreButton: .arcadiaButton, size: 35*smallButtonScale)
            }
            Spacer()
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

#Preview {
    ArcadiaButtonLayout(layoutElements: [.start, .backButtonsFirstRow, .dPad, .select, .fourActionButtons])
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
