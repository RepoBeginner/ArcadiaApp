//
//  CircleButtonView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/05/24.
//

import SwiftUI
import ArcadiaCore

struct CircleButtonView: View {
    private var arcadiaCoreButton: ArcadiaCoreButton
    private var color: Color
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState

    
    init(arcadiaCoreButton: ArcadiaCoreButton, color: Color = .gray) {
        self.arcadiaCoreButton = arcadiaCoreButton
        self.color = color
    }
    
    var body: some View {
        
        Button(action: {
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            #elseif os(macOS)
            //Second action that gets called
            if arcadiaCoreButton != .arcadiaButton {
                emulationState.unpressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton.rawValue)
            } else {
                emulationState.pauseEmulation()
                emulationState.showOverlay.toggle()
            }
            #endif
        }) {
            Image(systemName: arcadiaCoreButton.systemImageName)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.primary)
        }
        #if os(iOS)
        //TODO: Understand why this does not work on macOS
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    if arcadiaCoreButton != .arcadiaButton {
                        emulationState.pressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton.rawValue)
                    } else {
                        
                    }
                })
                .onEnded({ _ in
                    if arcadiaCoreButton != .arcadiaButton {
                        emulationState.unpressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton.rawValue)
                    } else {
                        emulationState.pauseEmulation()
                        emulationState.showOverlay.toggle()
                    }
                })
        )
        #elseif os(macOS)
        .buttonStyle(ButtonPressHandler {
            //First action that gets called
            if arcadiaCoreButton != .arcadiaButton {
                emulationState.pressButton(port: 0, device: 1, index: 0, button: arcadiaCoreButton.rawValue)
            } else {
                
            }
                })
        #endif

                

                       
    }
}

struct ButtonPressHandler: ButtonStyle {
    var action: () -> ()
    var pressAction: (Bool, Bool) -> () {
        return { first, second in
            if second {
                action()
            }
            
        }
    }
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ?
                             Color.blue.opacity(0.7) : Color.blue)   // just to look like system
            .onChange(of: configuration.isPressed, pressAction)
    }
}

#Preview {
    CircleButtonView(arcadiaCoreButton: .joypadA)
        .environment(ArcadiaCoreEmulationState.sharedInstance)
}

