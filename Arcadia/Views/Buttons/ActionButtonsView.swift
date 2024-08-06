//
//  ActionButtonsView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 06/08/24.
//

import SwiftUI
import ArcadiaCore

struct ActionButtonsView: View {
    
    private var numberOfButtons: Int
    
    init(numberOfButtons: Int) {
        self.numberOfButtons = numberOfButtons
    }
    
    var body: some View {
        VStack(spacing: 5) {
            if numberOfButtons == 4 {
                CircleButtonView(arcadiaCoreButton: .joypadX, size:50)
            } else {
                Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .opacity(0)
            }
                    HStack {
                        if numberOfButtons >= 3 {
                            CircleButtonView(arcadiaCoreButton: .joypadY, size:50)
                        } else {
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .opacity(0)
                        }
                        Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .opacity(0)
                        if numberOfButtons >= 2 {
                            CircleButtonView(arcadiaCoreButton: .joypadA, size:50)
                        } else {
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .opacity(0)
                        }
                        
                    }
            CircleButtonView(arcadiaCoreButton: .joypadB, size:50)
                }
    }
}

#Preview {
    ActionButtonsView(numberOfButtons: 4)
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}
