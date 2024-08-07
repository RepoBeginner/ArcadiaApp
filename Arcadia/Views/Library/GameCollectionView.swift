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
    @State private var showingRecommendationView: Bool = false
    @State private var showingRenameAlert = false
    @State private var gameBeingRenamed : URL?
    @State private var goToGameView : Bool = false
    @Binding private var path: NavigationPath
    @AppStorage("iCloudSyncEnabled") private var useiCloudSync = false
    @FocusState private var selectedGame: URL?
    @FocusState private var selectedGameIndex: Int?

    
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState
    @Environment(InputController.self) var inputController: InputController
    
    init(gameType: ArcadiaGameType, path: Binding<NavigationPath>) {
        self.gameType = gameType
        self._path = path

    }
    
    var body: some View {
        @Bindable var inputController = inputController
        Group {
            if fileManager.currentGames.isEmpty {
                EmptyCollectionView(gameType: gameType)
            } else {
                List {
                    ForEach(fileManager.currentGames, id: \.self) { file in
                        NavigationLink(destination: RunGameView(gameURL: file, gameType: gameType)
                        ) {
                            GameRowView(gameTitle: file.deletingPathExtension().lastPathComponent, gameURL: file, gameType: gameType)
                                .accessibilityHint("Play this game")

                        }
                    }
                }
                .navigationDestination(for: URL.self) { selection in
                    RunGameView(gameURL: selection, gameType: gameType)
                }
            }
        }
            .onAppear {
                fileManager.getGamesURL(gameSystem: gameType)
                if useiCloudSync {
                    fileManager.syncDataToiCloud()
                }
            }
            .navigationTitle("Game Collection")
                .toolbar() {
                    Button(action: { showingRecommendationView.toggle() }, label: {
                        Image(systemName: "lightbulb")
                    })
                    .accessibilityLabel("Recommendation")
                    .accessibilityHint("Get new games reccomendation")
                    Button(action: { showingAddGameView.toggle() }, label: {
                        Image(systemName: "plus")
                    })
                    .accessibilityLabel("Add new game")
                }
                .fileImporter(isPresented: $showingAddGameView, allowedContentTypes: gameType.allowedExtensions, allowsMultipleSelection: true, onCompletion: { result in
                    DispatchQueue.global(qos: .userInteractive).async {
                        do {
                            let fileUrls = try result.get()
                            for fileUrl in fileUrls {
                                fileManager.saveGame(gameURL: fileUrl, gameType: gameType)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("error reading: \(error.localizedDescription)")
                            }
                        }
                    }
                })
                .sheet(isPresented: $showingRecommendationView) {
                    RecommendationView(gameSystem: gameType)
                }
        #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
        #endif

    }
}


 #Preview {
     GameCollectionView(gameType: ArcadiaGameType.gameBoyGame, path: .constant(NavigationPath()))
 .environment(ArcadiaFileManager.shared)
 .environment(ArcadiaCoreEmulationState.sharedInstance)
 .environment(InputController.shared)
 }
 
