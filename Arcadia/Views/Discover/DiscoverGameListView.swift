//
//  DiscoverGameListView.swift
//  Arcadia
//
//  Created by Davide Andreoli on 27/08/24.
//

import SwiftUI

struct DiscoverGameListView: View {
    
    @State private var gameList: [ArcadiaFeaturedContent]
    
    init() {
        
        if let gamesUrl = Bundle.main.url(forResource: "ArcadiaFeaturedGames", withExtension: "plist"), let developersURL = Bundle.main.url(forResource: "ArcadiaFeaturedDevelopers", withExtension: "plist") {
            do {
                let gamesData = try Data(contentsOf: gamesUrl)
                let developersData = try Data(contentsOf: developersURL)
                let decoder = PropertyListDecoder()
                let games = try decoder.decode([ArcadiaFeaturedGame].self, from: gamesData)
                let developers = try decoder.decode([ArcadiaGameDeveloper].self, from: developersData)
                
                var content = [ArcadiaFeaturedContent]()
                
                for game in games {
                    if let developer = developers.first(where: { $0.id == game.developerId }) {
                        content.append(ArcadiaFeaturedContent(game: game, author: developer))
                    }
                    
                }
                
                self.gameList = content
                
            } catch {
                print("Decoding failed with error: \(error)")
                self.gameList = []
            }
        } else {
            print("No dice")
            self.gameList = []
        }
        
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ArcadiaGameType.allCases, id: \.self) { section in
                    if !gameList.filter({ $0.game.gameType == section }).isEmpty {
                        Section(section.name) {
                            ForEach(gameList.filter({ $0.game.gameType == section }), id: \.self) { content in
                                NavigationLink(destination: DiscoverGameDetailView(game: content)) {
                                    DiscoverGameRowView(game: content)
                                }
                                
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("Featured Games")
        }
    }
}

#Preview {
    DiscoverGameListView()
}
