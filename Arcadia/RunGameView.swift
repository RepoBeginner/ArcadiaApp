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
            CurrentBufferMetalView(pixelData: $emulationState.mainBuffer, audioData: $emulationState.currentAudioFrameFloat, width: emulationState.audioVideoInfo?.geometry.width ?? 1, height: emulationState.audioVideoInfo?.geometry.height ?? 1)
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
                })
            HStack {
                CapsuleButtonView(arcadiaCoreButton: .joypadStart, buttonText: "Start", color: Color.gray)
                CapsuleButtonView(arcadiaCoreButton: .joypadSelect, buttonText: "Select", color: Color.gray)
            }

            HStack {
                DPadView()
                Spacer()
                TwoButtonsView()
            }
            .padding(.horizontal, 5)
        }

    }


}


/*
#Preview {
    RunGameView(gameURL: URL(fileURLWithPath: "e"))
}
*/

