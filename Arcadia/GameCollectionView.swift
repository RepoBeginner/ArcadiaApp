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
    
    init(gameType: ArcadiaGameType) {
        self.gameType = gameType
    }
    
    var body: some View {
            List {
                ForEach(fileManager.getGamesURL(gameSystem: gameType), id: \.self) { file in
                    NavigationLink(destination: RunGameView(gameURL: file, gameType: gameType)
                        .environment(ArcadiaCoreEmulationState.sharedInstance)
                        .environment(fileManager)
                    ) {
                        Text(file.deletingPathExtension().lastPathComponent)
                    }
                    }
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

    }
}

#Preview {
    GameCollectionView(gameType: ArcadiaGameType.gameBoyGame)
        .environment(ArcadiaFileManager.shared)
}
