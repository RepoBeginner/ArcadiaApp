//
//  GameIconView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 08/05/24.
//

import SwiftUI

struct GameRowView: View {
    
    @State private var gameTitle: String
    private var gameType: ArcadiaGameType
    private var gameURL: URL
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    @State private var imageData: Data?
    @State private var showingRenameAlert = false
    @State private var newGameName: String = ""
    
    init(gameTitle: String, gameURL: URL, gameType: ArcadiaGameType) {
        self.gameTitle = gameTitle
        self.gameType = gameType
        self.gameURL = gameURL
    }
    
    var body: some View {
        HStack {
            //TODO: if the image is loaded when the row is on screen, the image should update
            if let imageData = fileManager.getImageData(gameURL: gameURL, gameType: gameType) {
                #if os(macOS)
                Image(nsImage: NSImage(data: imageData)!)
                    .frame(width: 80, height: 80)
                #else
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .frame(width: 80, height: 80)
                #endif
            } else {
                ZStack {
                    gameType.defaultCollectionImage
                }
                .frame(width: 80, height: 80)
            }

            Text(gameTitle)
                .font(.headline)
        }
        .swipeActions(allowsFullSwipe: false) {
            Button(role: .destructive) {
                fileManager.deleteGame(gameURL: gameURL, gameType: gameType)
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
            Button {
                showingRenameAlert.toggle()
            } label: {
                Label("Rename", systemImage: "square.and.pencil")
            }
        }
        .contextMenu(menuItems: {
            Button(role: .destructive) {
                fileManager.deleteGame(gameURL: gameURL, gameType: gameType)
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
            Button {
                showingRenameAlert.toggle()
                newGameName = gameURL.deletingPathExtension().lastPathComponent
            } label: {
                Label("Rename", systemImage: "square.and.pencil")
            }
        })
        .alert("Enter your name", isPresented: $showingRenameAlert) {
            TextField("Enter the new game name", text: $newGameName)
            Button("Confirm", action: {
                fileManager.renameGame(gameURL: gameURL, newName: newGameName, gameType: gameType)
            })
            Button("Cancel", role: .cancel) {
                newGameName = ""
            }
        } message: {
            Text("Enter the new name for the game.")
        }
        
    }
}

#Preview {
    GameRowView(gameTitle: "Pokemon - Versione Cristallo", gameURL: URL(string: "file://path.it")!, gameType: .gameBoyGame)
        .environment(ArcadiaFileManager.shared)
}
