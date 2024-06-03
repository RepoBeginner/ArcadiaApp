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
    @State private var showingRenameAlert = false
    @State private var newGameName = ""
    @State private var gameBeingRenamed : URL?
    
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    @Environment(ArcadiaCoreEmulationState.self) var emulationState: ArcadiaCoreEmulationState
    
    init(gameType: ArcadiaGameType) {
        self.gameType = gameType

    }
    
    var body: some View {
            let renameButton =
        
        
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
                                Button {
                                    showingRenameAlert.toggle()
                                    gameBeingRenamed = file
                                    newGameName = file.deletingPathExtension().lastPathComponent
                                } label: {
                                    Label("Rename", systemImage: "square.and.pencil")
                                }
                            }
                            .contextMenu(menuItems: {
                                Button(role: .destructive) {
                                    fileManager.deleteGame(gameURL: file, gameType: gameType)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                Button {
                                    showingRenameAlert.toggle()
                                    gameBeingRenamed = file
                                    newGameName = file.deletingPathExtension().lastPathComponent
                                } label: {
                                    Label("Rename", systemImage: "square.and.pencil")
                                }
                            })
                            .alert("Enter your name", isPresented: $showingRenameAlert) {
                                TextField("Enter the new game name", text: $newGameName)
                                Button("Confirm", action: {
                                    fileManager.renameGame(gameURL: gameBeingRenamed!, newName: newGameName, gameType: gameType)
                                    gameBeingRenamed = nil
                                })
                                Button("Cancel", role: .cancel) {
                                    gameBeingRenamed = nil
                                    newGameName = ""
                                }
                            } message: {
                                Text("Enter the new name for the game.")
                            }
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
 
