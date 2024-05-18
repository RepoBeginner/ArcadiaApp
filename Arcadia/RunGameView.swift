//
//  ContentView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 01/05/24.
//

import SwiftUI
import SwiftData
import ArcadiaGBCCore
import ArcadiaCore
import AVFoundation



struct RunGameView: View {
    @State private var gameURL: URL
    @FocusState private var isFocused: Bool
    @State private var gameCore: any ArcadiaCoreProtocol
    @Environment(ArcadiaCoreEmulationState.self) private var emulationState: ArcadiaCoreEmulationState
    
    init(gameURL: URL, gameCore: any ArcadiaCoreProtocol) {
        self.gameURL = gameURL
        self.gameCore = gameCore
    }

    var body: some View {
        @Bindable var emulationState = emulationState
        VStack{
            //MetalView()
            //CurrentFrameView(currentFrame: $emulationState.currentFrame)
            CurrentBufferMetalView(pixelData: $emulationState.mainBuffer, audioData: $emulationState.currentAudioFrame, width: emulationState.audioVideoInfo?.geometry.width ?? 1, height: emulationState.audioVideoInfo?.geometry.height ?? 1)
                .scaledToFit()
                .focusable()
                .focused($isFocused)
                .onKeyPress( action: { keypress in
                    switch keypress.key {
                    case .return:
                        emulationState.pressButton(button: .joypadStart)
                        return .handled
                    default:
                        return .ignored
                    }
                })
                .onAppear(perform: {
                    isFocused = true
                    emulationState.attachCore(core: gameCore)
                    emulationState.startEmulation(gameURL: gameURL)
                })
                .onDisappear(perform: {
                    emulationState.pauseEmulation()
                    //metalView.coordia
                })
            HStack {
                CapsuleButtonView(arcadiaCoreButton: .joypadStart, buttonText: "Start", color: Color.gray)
                CapsuleButtonView(arcadiaCoreButton: .joypadSelect, buttonText: "Select", color: Color.gray)
            }

            HStack {
                DPadView()
                Spacer()
                HStack {
                    CircleButtonView(arcadiaCoreButton: .joypadA, buttonText: "A", color: Color.red)
                    CircleButtonView(arcadiaCoreButton: .joypadB, buttonText: "B", color: Color.red)
                }
            }
        }

    }


}


/*
#Preview {
    RunGameView(gameURL: URL(fileURLWithPath: "e"))
}
*/

