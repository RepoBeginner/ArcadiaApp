//
//  GameLibraryView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import SwiftUI

struct GameLibraryView: View {
    @State private var system: ArcadiaGameType?

    
    var body: some View {

        NavigationSplitView {
            List(ArcadiaGameType.allCases, selection: $system) { gameType in
                    GameSystemRowView(gameSystem: gameType)
            }
            .navigationTitle("Game Systems")
        } detail: {
            if let selection = system {
                NavigationStack {
                    GameCollectionView(gameType: selection)
                }

            } else {
                Text("Select a system")
            }
        }
        

    }
}

#Preview {
    GameLibraryView()
}
