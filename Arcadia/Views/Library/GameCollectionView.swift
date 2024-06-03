//
//  GameCollectionView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI
import UniformTypeIdentifiers
import ArcadiaCore

struct GameCollectionView: View {
    @State private var gameType: ArcadiaGameType
    @State private var showingAddGameView: Bool = false
    
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState
    
    init(gameType: ArcadiaGameType) {
        self.gameType = gameType

    }
    
    var body: some View {
            List {
                ForEach(fileManager.currentGames, id: \.self) { file in
                    NavigationLink(destination: RunGameView(gameURL: file, gameType: gameType)
                    ) {
                        GameRowView(gameTitle: file.deletingPathExtension().lastPathComponent, gameURL: file, gameType: gameType)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    fileManager.deleteGame(gameURL: file, gameType: gameType)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        //TODO: when the row is deleted the view is not updated?
                            .contextMenu(menuItems: {
                                Button(role: .destructive) {
                                    fileManager.deleteGame(gameURL: file, gameType: gameType)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            })
                    }
                    }
            }
            .onAppear {
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
 
