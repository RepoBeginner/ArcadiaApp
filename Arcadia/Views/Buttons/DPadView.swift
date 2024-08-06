//
//  ArrowButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct DPadView: View {
    
    @AppStorage("useAdvancedDPad") private var useAdvancedDPad = true
    
    var body: some View {
        if useAdvancedDPad {
            VStack(spacing: 5) {
            
                HStack {
                    CircleButtonView(arcadiaCoreButton: .joypadUpLeft, size:50)
                    CircleButtonView(arcadiaCoreButton: .joypadUp, size:50)
                    CircleButtonView(arcadiaCoreButton: .joypadUpRight, size:50)
                }
                        HStack {
                            CircleButtonView(arcadiaCoreButton: .joypadLeft, size:50)
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .opacity(0)
                            CircleButtonView(arcadiaCoreButton: .joypadRight, size:50)
                            
                        }
                HStack {
                    CircleButtonView(arcadiaCoreButton: .joypadDownLeft, size:50)
                    CircleButtonView(arcadiaCoreButton: .joypadDown, size:50)
                    CircleButtonView(arcadiaCoreButton: .joypadDownRight, size:50)
                }
                    }
        } else {
            VStack(spacing: 5) {
            
                CircleButtonView(arcadiaCoreButton: .joypadUp, size:50)
                        HStack {
                            CircleButtonView(arcadiaCoreButton: .joypadLeft, size:50)
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .opacity(0)
                            CircleButtonView(arcadiaCoreButton: .joypadRight, size:50)
                            
                        }
                CircleButtonView(arcadiaCoreButton: .joypadDown, size:50)
                    }
        }
 
    }
}

#Preview {
    HStack {
        Spacer()
        DPadView()
            .environment(ArcadiaCoreEmulationState.sharedInstance)
            .environment(InputController.shared)
        Spacer()
    }
    .frame(width: 50, height: 300)
}

