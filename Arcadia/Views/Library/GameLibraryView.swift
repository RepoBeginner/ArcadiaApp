//
//  GameLibraryView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI

struct GameLibraryView: View {
    @State private var system: ArcadiaGameType?
    @FocusState private var selectedSystem: ArcadiaGameType?
    @State private var path = NavigationPath()
    
    var body: some View {

        NavigationSplitView {
            List(ArcadiaGameType.allCases, selection: $system) { gameType in
                NavigationLink(value: gameType) {
                    GameSystemRowView(gameSystem: gameType)
                        .accessibilityHint("Open this console's collection")
                }
            }
            .navigationTitle("Game Consoles")
        } detail: {
            if let selectedSystem = system {
                NavigationStack(path: $path) {
                    GameCollectionView(gameType: selectedSystem, path: $path)
                        .id(selectedSystem.id)
                        .navigationTitle("Game Collection")
                    #if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
                    #endif
                }

            } else {
                Text("Select a game console using the sidebar")
            }
        }

        

    }
}

#Preview {
    GameLibraryView()
}
