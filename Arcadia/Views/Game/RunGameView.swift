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

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dismiss) var dismiss
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    
    init(gameURL: URL, gameType: ArcadiaGameType) {
        self.gameURL = gameURL
        self.gameType = gameType
    }

    var body: some View {
        @Bindable var emulationState = emulationState
        Group {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                VStack {
                    CurrentBufferMetalView()
                        .scaledToFit()
                    Spacer()
                    gameType.portraitButtonLayout

                }
            }
            else {
                HStack {
                    gameType.landscapeButtonLayoutLeft
                    Spacer()
                    CurrentBufferMetalView()
                        .scaledToFill()
                    Spacer()
                    gameType.landscapeButtonLayoutRight

                }
            }
        }
        .onAppear(perform: {
            //TODO: Invece del gameURL mandare uno struct con tutte le informazioni
            let stateURL = fileManager.getStateURL(gameURL: gameURL, gameType: gameType)
            var saveFIleURLs: [ArcadiaCoreMemoryType : URL] = [:]
            for memoryType in gameType.supportedSaveFiles.keys {
                saveFIleURLs[memoryType] = fileManager.getSaveURL(gameURL: gameURL, gameType: gameType, memoryType: memoryType)
            }
            emulationState.startEmulation(gameURL: gameURL, gameType: gameType, stateURL: stateURL, saveFileURLs: saveFIleURLs)
        })
        .onDisappear(perform: {
            emulationState.pauseEmulation()
        })
        .onChange(of: toDismiss) { oldValue, newValue in
            if newValue {
                dismiss()
            }
            
        }
        .sheet(isPresented: $emulationState.showOverlay, content: {
            OverlayView(dismissMainView: $toDismiss)
        })
    #if os(iOS)
        .toolbar(.hidden, for: .tabBar)
    #endif

    }


}



#Preview {
    RunGameView(gameURL: URL(fileURLWithPath: "e"), gameType: .gameBoyGame)
}


