//
//  iRetroGame.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import Foundation
import SwiftData
import ArcadiaCore

struct ArcadiaGame {
    var gameType: ArcadiaGameType
    var gameURL: URL
    
    init(gameType: ArcadiaGameType, gameURL: URL) {
        self.gameType = gameType
        self.gameURL = gameURL
    }
    
    var imageURL: URL {
        return ArcadiaFileManager.shared.getImageURL(gameURL: gameURL, gameType: gameType)
    }
    
    var stateURL: URL {
        return ArcadiaFileManager.shared.getStateURL(gameURL: gameURL, gameType: gameType, slot: 1)
    }
    
    func saveURL(memoryType: ArcadiaCoreMemoryType) -> URL {
        return ArcadiaFileManager.shared.getSaveURL(gameURL: gameURL, gameType: gameType, memoryType: memoryType)
    }
    
}

/*
@Model
final class ArcadiaGame {
    var gameType: ArcadiaGameType
    var name: String
    var id: UUID
    var internalName: String
    
    init(name: String, gameType: ArcadiaGameType) {
        self.gameType = gameType
        self.name = name
        let id = UUID()
        self.id = id
        self.internalName = id.uuidString
    }
    
}
*/
