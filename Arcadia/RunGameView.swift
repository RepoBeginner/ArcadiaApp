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
    @State private var toDismiss: Bool = false
    @Environment(\.dismiss) var dismiss
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
                .onAppear(perform: {
                    emulationState.attachCore(core: gameType.associatedCore)
                    emulationState.currentSaveFolder = fileManager.getSaveURL(gameURL: gameURL, gameType: gameType)
                    emulationState.startEmulation(gameURL: gameURL)
                })
                .onDisappear(perform: {
                    emulationState.pauseEmulation()
                })
                .onChange(of: toDismiss) { oldValue, newValue in
                    if newValue {
                        dismiss()
                    }
                    
                }

            GBCButtonLayout()
                .sheet(isPresented: $emulationState.showOverlay, content: {
                    OverlayView(dismissMainView: $toDismiss)
                })
            #if os(iOS)
                .toolbar(.hidden, for: .tabBar)
            #endif


        }

    }


}



#Preview {
    RunGameView(gameURL: URL(fileURLWithPath: "e"), gameType: .gameBoyGame)
}


