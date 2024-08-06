//
//  ContentView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 01/05/24.
//

import SwiftUI
import SwiftData
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
    @Environment(InputController.self) var inputController: InputController
    
    @AppStorage("iCloudSyncEnabled") private var useiCloudSync = false
    @AppStorage("hideButtons") private var hideButtons = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(gameURL: URL, gameType: ArcadiaGameType) {
        self.gameURL = gameURL
        self.gameType = gameType
    }

    var body: some View {
        @Bindable var emulationState = emulationState
        Group {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                //iPhone portrait
                VStack {
                    CurrentBufferMetalView()
                        .scaledToFit()
                    Spacer()
                    if !hideButtons {
                        ArcadiaButtonLayout(layoutElements: gameType.buttonLayoutElements)
                        
                    } else {
                        ArcadiaButtonOnlyLayout()
                    }

                }
            }
            else if horizontalSizeClass == .regular && verticalSizeClass == .compact {
                //iPhone landscape
                HStack {
                    if !hideButtons {
                        ArcadiaButtonLayoutLeft(layoutElements: gameType.buttonLayoutElements)
                    } else {
                        ArcadiaButtonOnlyLayout()
                    }
                    Spacer()
                    CurrentBufferMetalView()
                        .scaledToFit()
                        .layoutPriority(1)
                    Spacer()
                    if !hideButtons {
                        ArcadiaButtonLayoutRight(layoutElements: gameType.buttonLayoutElements)
                    } else {
                        
                    }
                }
            }
            else {
                ZStack {
                    CurrentBufferMetalView()
                        .layoutPriority(1)
                        .scaledToFit()
                    //Spacer()
                    VStack {
                        Spacer()
                        if !hideButtons {
                            ArcadiaButtonLayout(layoutElements: gameType.buttonLayoutElements)
                        } else {
                            ArcadiaButtonOnlyLayout()
                        }
                            
                    }


                }
                
            }
        }
        .onAppear(perform: {
            //inputController.loadGameConfiguration()
            //TODO: Invece del gameURL mandare uno struct con tutte le informazioni
            var stateURLs: [Int : URL] = [:]
            for i in 1...3 {
                stateURLs[i] = fileManager.getStateURL(gameURL: gameURL, gameType: gameType, slot: i)
            }
            var saveFIleURLs: [ArcadiaCoreMemoryType : URL] = [:]
            for memoryType in gameType.supportedSaveFiles.keys {
                saveFIleURLs[memoryType] = fileManager.getSaveURL(gameURL: gameURL, gameType: gameType, memoryType: memoryType)
            }
            emulationState.startEmulation(gameURL: gameURL, gameType: gameType, stateURLs: stateURLs, saveFileURLs: saveFIleURLs)
        })
        .onDisappear(perform: {
            //inputController.unloadGameConfiguration()
            emulationState.pauseEmulation()
            if useiCloudSync {
                for memoryType in gameType.supportedSaveFiles.keys {
                    fileManager.createCloudCopy(of: fileManager.getSaveURL(gameURL: gameURL, gameType: gameType, memoryType: memoryType))
                }
            }

        })
        .onReceive(timer) { _ in
            if useiCloudSync {
                for memoryType in gameType.supportedSaveFiles.keys {
                    fileManager.createCloudCopy(of: fileManager.getSaveURL(gameURL: gameURL, gameType: gameType, memoryType: memoryType))
                }
            }
        }
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


