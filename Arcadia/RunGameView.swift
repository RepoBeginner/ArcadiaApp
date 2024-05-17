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
    @Environment(ArcadiaGBC.self) private var core: ArcadiaGBC
    @Environment(ArcadiaCoreEmulationState.self) private var emulationState: ArcadiaCoreEmulationState
    
    init(gameURL: URL) {
        self.gameURL = gameURL
    }

    var body: some View {
        @Bindable var core = core
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
                        core.pressButton(button: .joypadStart)
                        return .handled
                    default:
                        return .ignored
                    }
                })
                .onAppear(perform: {
                    isFocused = true
                    // TODO: Change implementation, the frontend should not worry about all these things
                    if emulationState.currentGameURL != nil {
                        if emulationState.currentGameURL == gameURL {
                            core.resumeGame()
                        } else {
                            core.stopGameLoop()
                            core.unloadGame()
                            //TODO: Understand if it's really necessary to deinit the core
                            core.deinitializeCore()
                            core.initializeCore()
                            core.loadGame(gameURL: gameURL)
                            core.setInputOutputCallbacks()
                            core.startGameLoop()
                        }
                    } else {
                        core.initializeCore()
                        core.loadGame(gameURL: gameURL)
                        core.setInputOutputCallbacks()
                        core.startGameLoop()
                    }


                })
                .onDisappear(perform: {
                    core.pauseGame()
                    //metalView.coordia
                })
            HStack {
                Button("Start") {
                    core.pressButton(button: .joypadStart)
                }
                Button("Select") {
                    core.pressButton(button: .joypadSelect)
                }
            }
            HStack {
                VStack {
                    Button(action: {
                        core.pressButton(button: .joypadUp)
                    }) {
                        Image(systemName: "arrowtriangle.up.fill")
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    HStack {
                        Button(action: {
                            core.pressButton(button: .joypadLeft)
                        }) {
                            Image(systemName: "arrowtriangle.left.fill")
                                .padding()
                                .background(Color.gray.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        Button(action: {
                            core.pressButton(button: .joypadRight)
                        }) {
                            Image(systemName: "arrowtriangle.right.fill")
                                .padding()
                                .background(Color.gray.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    Button(action: {
                        core.pressButton(button: .joypadDown)
                    }) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                HStack {
                    Button(action: {
                        core.pressButton(button: .joypadA)
                    }) {
                        Text("A")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        core.pressButton(button: .joypadB)
                    }) {
                        Text("B")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }

    }


}


#Preview {
    RunGameView(gameURL: URL(fileURLWithPath: "e"))
}


