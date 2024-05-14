//
//  GameLibraryView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI

struct GameLibraryView: View {
    @State private var system: iRetroGameType = iRetroGameType.gameBoyGame
    
    var body: some View {
        #if os(macOS)
        NavigationSplitView {
            List(iRetroGameType.allCases, selection: $system) { gameType in
                NavigationLink(destination: GameCollectionView(gameType: gameType)) {
                    Text(gameType.rawValue)
                }
            }
        } detail: {
            Text("Hello")
        }
        #else
        NavigationStack {
            List(iRetroGameType.allCases) { gameType in
                NavigationLink(destination: GameCollectionView(gameType: gameType)) {
                    Text(gameType.rawValue)
                }
            }
            .navigationTitle("Game Systems")
        }
        #endif
    }
}

#Preview {
    GameLibraryView()
}
