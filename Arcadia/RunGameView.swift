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

import GameController

#if os(macOS)
import AppKit
#else
import UIKit
#endif


struct RunGameView: View {
    @State private var gameURL: URL
    @State private var gameType: ArcadiaGameType
    @FocusState private var isFocused: Bool
    @Environment(ArcadiaCoreEmulationState.self) private var emulationState: ArcadiaCoreEmulationState
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    
    init(gameURL: URL, gameType: ArcadiaGameType) {
        self.gameURL = gameURL
        self.gameType = gameType
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
                    emulationState.attachCore(core: gameType.associatedCore)
                    emulationState.currentSaveFolder = fileManager.getSaveURL(gameURL: gameURL, gameType: gameType)
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
                .padding(.horizontal)
            }
        }

    }


}


/*
#Preview {
    RunGameView(gameURL: URL(fileURLWithPath: "e"))
}
*/

