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
import ArcadiaNESCore
import SwiftUI

enum ArcadiaGameType: String, Codable, CaseIterable, Identifiable, ArcadiaGameTypeProtocol {
    
    var id: Self {
        return self
    }
    
    case gameBoyGame = "GameBoy (Color)"
    case nesGame = "NES"
    
    var allowedExtensions: [UTType] {
        switch self {
        case .gameBoyGame:
            return [UTType(filenameExtension: "gb")!, UTType(filenameExtension: "gbc")!, UTType(filenameExtension: "sgb")!, UTType(filenameExtension: "cgb")!]
        case .nesGame:
            return [UTType(filenameExtension: "nes")!]
        }
        
    }
    
    var associatedCore: any ArcadiaCoreProtocol {
        switch self {
        case .gameBoyGame:
            return ArcadiaGBC()
        case .nesGame:
            return ArcadiaNES()
        }
    }
    
    var saveFileExtension: String {
        switch self {
        case .gameBoyGame:
            return "srm"
        case .nesGame:
            return "srm"
        }
    }
    
    var defaultCollectionImage: Image {
        switch self {
        case .gameBoyGame:
            return Image("gbc_icon")
        case .nesGame:
            return Image("gbc_icon")
        }
    }
    

}
