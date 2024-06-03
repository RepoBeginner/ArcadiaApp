//
//  GameIconView.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 08/05/24.
//

import SwiftUI

struct GameRowView: View {
    
    private var gameTitle: String
    private var gameType: ArcadiaGameType
    private var gameURL: URL
    @Environment(ArcadiaFileManager.self) var fileManager: ArcadiaFileManager
    @State private var imageData: Data?
    
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
        
    }
}

#Preview {
    GameRowView(gameTitle: "Pokemon - Versione Cristallo", gameURL: URL(string: "file://path.it")!, gameType: .gameBoyGame)
        .environment(ArcadiaFileManager.shared)
}
