//
//  ArcadiaGameType.swift
//  Arcadia
//
//  Created by Davide Andreoli on 18/05/24.
//

import Foundation
import UniformTypeIdentifiers
import ArcadiaCore
import ArcadiaGBCCore

enum ArcadiaGameType: String, Codable, CaseIterable, Identifiable {
    
    var id: Self {
        return self
    }
    
    case gameBoyGame = "GameBoy (Color)"
    
    var allowedExtensions: [UTType] {
        switch self {
        case .gameBoyGame:
            return [UTType(filenameExtension: "gb")!, UTType(filenameExtension: "gbc")!, UTType(filenameExtension: "sgb")!, UTType(filenameExtension: "cgb")!]
        }
    }
    
    var associatedCore: any ArcadiaCoreProtocol {
        switch self {
        case .gameBoyGame:
            return ArcadiaGBC()
        }
    }
    

}
