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
    
    init(gameType: ArcadiaGameType) {
        self.gameType = gameType
    }
    
    var body: some View {
        VStack {
            Text("Your game collection is empty, add new games using the plus button at the top.")
            Text("With this console you can open games in the following formats:")
            ForEach(gameType.allowedExtensions, id: \.self) { allowedExtension in
                Text("\(allowedExtension.tags[.filenameExtension]?.joined(separator: "\n") ?? "NIL")")
                
            }
        }
        .padding()
        
    }
}

#Preview {
    EmptyCollectionView(gameType: .gameBoyGame)
}
