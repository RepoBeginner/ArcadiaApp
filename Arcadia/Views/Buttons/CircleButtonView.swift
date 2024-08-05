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
    private var size: CGFloat
    @AppStorage("hapticFeedback") private var useHapticFeedback = true
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState
    @Environment(InputController.self) var inputController: InputController
    
    init(arcadiaCoreButton: ArcadiaCoreButton, color: Color = .gray, size: CGFloat) {
        self.arcadiaCoreButton = arcadiaCoreButton
        self.color = color
        self.size = size
    }
    
    var body: some View {
        
        Button(action: {
            #if os(iOS)
            if useHapticFeedback {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
            #elseif os(macOS)
            //Second action that gets called
            if arcadiaCoreButton != .arcadiaButton {
                emulationState.unpressButton(port: inputController.mainInputPortID, device: 1, index: 0, button: arcadiaCoreButton)
            } else {
                emulationState.pauseEmulation()
                emulationState.showOverlay.toggle()
            }
            #endif
        }) {
            Image(systemName: arcadiaCoreButton.systemImageName)
                .resizable()
                .frame(width: size, height: size)
#if os(iOS)
                .foregroundStyle(color)
            #endif
        }
        .accessibilityLabel(arcadiaCoreButton.buttonName)
        #if os(iOS)
        //TODO: Understand why this does not work on macOS
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in
                    if arcadiaCoreButton != .arcadiaButton {
                        emulationState.pressButton(port: inputController.mainInputPortID, device: 1, index: 0, button: arcadiaCoreButton)
                    } else {
                        
                    }
                })
                .onEnded({ _ in
                    if arcadiaCoreButton != .arcadiaButton {
                        emulationState.unpressButton(port: inputController.mainInputPortID, device: 1, index: 0, button: arcadiaCoreButton)
                    } else {
                        emulationState.pauseEmulation()
                        emulationState.showOverlay.toggle()
                    }
                })
        )
        #elseif os(macOS)
        .buttonStyle(ButtonPressHandler(color: color) {
            //First action that gets called
            if arcadiaCoreButton != .arcadiaButton {
                emulationState.pressButton(port: inputController.mainInputPortID, device: 1, index: 0, button: arcadiaCoreButton)
            } else {
                
            }
                })
        #endif

                

                       
    }
}

struct ButtonPressHandler: ButtonStyle {
    var color: Color
    var action: () -> ()
    var pressAction: (Bool, Bool) -> () {
        return { first, second in
            if second {
                action()
            }
            
        }
    }
    
    init(color: Color, action: @escaping () -> Void) {
        self.color = color
        self.action = action
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundStyle(color)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .onChange(of: configuration.isPressed, pressAction)
    }
}

#Preview {
    CircleButtonView(arcadiaCoreButton: .joypadA, size: 50)
        .environment(ArcadiaCoreEmulationState.sharedInstance)
        .environment(InputController.shared)
}

