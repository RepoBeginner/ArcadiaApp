//
//  EmptyCollectionView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 17/07/24.
//

import SwiftUI
import UniformTypeIdentifiers
import ArcadiaCore

struct EmptyCollectionView: View {
    
    @State private var gameType: ArcadiaGameType
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("iCloudSyncEnabled") private var useiCloudSync = false
    
    init(gameType: ArcadiaGameType) {
        self.gameType = gameType
    }
    
    var body: some View {
        Form {
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Your game collection is empty, add new games using the plus button at the top.")
                    Text("With this console you can open games in the following formats:")
                    ForEach(gameType.allowedExtensions, id: \.self) { allowedExtension in
                        Text("\t.\(allowedExtension.tags[.filenameExtension]?.joined(separator: "\n\t.") ?? "NIL")")
                    }
                    Text("If your game does not show up, or if you loaded the game manually, you can pull to refresh this view, or use the button below.")
                }
                Button(action: {
                    fileManager.getGamesURL(gameSystem: gameType)
                    if useiCloudSync {
                        fileManager.syncDataToiCloud()
                    }
                }) {
                    Text("Refresh game list")
                }
                .buttonStyle(BorderedButtonStyle())
                
            }
            
            
        }
        .refreshable {
            fileManager.getGamesURL(gameSystem: gameType)
            if useiCloudSync {
                fileManager.syncDataToiCloud()
            }
        }
                
    }
}

#Preview {
    EmptyCollectionView(gameType: .gameBoyGame)
        .environment(ArcadiaFileManager.shared)
}
