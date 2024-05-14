//
//  ContentView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 01/05/24.
//

import SwiftUI
import SwiftData
import iRetroGBCCore
import iRetroCore
import AVFoundation




struct RunGameView: View {
    @State private var gameURL: URL
    @FocusState private var isFocused: Bool
    @Environment(iRetroGBC.self) private var core: iRetroGBC
    @Environment(iRetroCoreEmulationState.self) private var emulationState: iRetroCoreEmulationState
    
    init(gameURL: URL) {
        self.gameURL = gameURL
    }

    var body: some View {
        @Bindable var core = core
        @Bindable var emulationState = emulationState
        VStack{
            CurrentFrameView(currentFrame: $emulationState.currentFrame)
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
                    if core.loadedGame != nil {
                        if core.loadedGame == gameURL {
                            core.resumeGame()
                        } else {
                            core.stopGameLoop()
                            core.retroUnloadGame()
                            //TODO: Understand if it's really necessary to deinit the core
                            core.retroDeinit()
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
                })
            Button("Run game") {
                core.startGameLoop()
            }
            HStack {
                Button("Start") {
                    core.pressButton(button: .joypadStart)
                }
                Button("Select") {
                    core.pressButton(button: .joypadSelect)
                }
            }
            VStack {
                Button("Up") {
                    core.pressButton(button: .joypadUp)
                }
                HStack {
                    Button("Left") {
                        core.pressButton(button: .joypadLeft)
                    }
                    Button("Right") {
                        core.pressButton(button: .joypadRight)
                    }
                }
                Button("Down") {
                    core.pressButton(button: .joypadDown)
                }
            }
            HStack {
                Button("A") {
                    core.pressButton(button: .joypadA)
                }
                Button("B") {
                    core.pressButton(button: .joypadB)
                }
            }
        }

    }


}


#Preview {
    RunGameView(gameURL: URL(fileURLWithPath: "e"))
}
