//
//  GameCollectionView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI
import UniformTypeIdentifiers
import ArcadiaCore
import GameController

struct GameCollectionView: View {
    
    @State private var gameType: ArcadiaGameType
    @State private var showingAddGameView: Bool = false
    @State private var showingRenameAlert = false
    @State private var gameBeingRenamed : URL?
    @FocusState private var selectedGame: URL?
    @FocusState private var selectedGameIndex: Int?
    
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState
    @Environment(InputController.self) var inputController: InputController
    
    init(gameType: ArcadiaGameType) {
        self.gameType = gameType

    }
    
    var body: some View {
        @Bindable var inputController = inputController
        Group {
            if fileManager.currentGames.isEmpty {
                Text("Add new games")
            } else {
                List {
                    ForEach(fileManager.currentGames, id: \.self) { file in
                        NavigationLink(destination: RunGameView(gameURL: file, gameType: gameType)
                        ) {
                            GameRowView(gameTitle: file.deletingPathExtension().lastPathComponent, gameURL: file, gameType: gameType)
                                .focusable(true)
                                .focused($selectedGameIndex, equals: fileManager.currentGames.firstIndex(of: file))

                        }
                    }
                }
                .onChange(of: inputController.action) {oldValue, newValue in
                    if inputController.action == .moveDown {
                        selectedGameIndex? += 1
                    }
                }

            }
        }
            .onAppear {
                selectedGameIndex = 0
                fileManager.getGamesURL(gameSystem: gameType)

            }
            .navigationTitle("Game Collection")
                .toolbar() {
                    Button(action: { showingAddGameView.toggle() }, label: {
                        Image(systemName: "plus")
                    })
                }
                .fileImporter(isPresented: $showingAddGameView, allowedContentTypes: gameType.allowedExtensions, onCompletion: { result in
                    //TODO: Handle multiple files
                    do {
                        let fileUrl = try result.get()
                        fileManager.saveGame(gameURL: fileUrl, gameType: gameType)
                    } catch {
                        print ("error reading: \(error.localizedDescription)")
                    }
                    return
                })
        #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
        #endif

    }
}


 #Preview {
 GameCollectionView(gameType: ArcadiaGameType.gameBoyGame)
 .environment(ArcadiaFileManager.shared)
 }
 
