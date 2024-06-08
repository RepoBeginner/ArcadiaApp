//
//  ArcadiaGameType.swift
//  Arcadia
//
//  Created by Davide Andreoli on 18/05/24.
//

import Foundation
import UniformTypeIdentifiers
import ArcadiaCore
import ArcadiaGBACore
import ArcadiaGBCCore
import ArcadiaNESCore
import SwiftUI

enum ArcadiaGameType: String, Codable, CaseIterable, Identifiable, ArcadiaGameTypeProtocol {
    
    var id: Self {
        return self
    }
    
    case gameBoyAdvanceGame = "GameBoy Advance"
    case gameBoyGame = "GameBoy (Color)"
    case nesGame = "NES"
    
    var name: String {
        switch self {
        case .gameBoyGame:
            return "GameBoy (Color)"
        case .gameBoyAdvanceGame:
            return "GameBoy Advance"
        case .nesGame:
            return "NES"
        }
    }
    
    var allowedExtensions: [UTType] {
        switch self {
        case .gameBoyGame:
            return [UTType(filenameExtension: "gb")!, UTType(filenameExtension: "gbc")!, UTType(filenameExtension: "sgb")!, UTType(filenameExtension: "cgb")!]
        case .gameBoyAdvanceGame:
            return [UTType(filenameExtension: "gba")!]
        case .nesGame:
            return [UTType(filenameExtension: "nes")!]
        }
        
    }
    
    var associatedCore: any ArcadiaCoreProtocol {
        switch self {
        case .gameBoyAdvanceGame:
            return ArcadiaGBA()
        case .gameBoyGame:
            return ArcadiaGBC()
        case .nesGame:
            return ArcadiaNES()
        }
    }
    
    var saveFileExtension: String {
        switch self {
        case .gameBoyAdvanceGame:
            return "sav"
        case .gameBoyGame:
            return "srm"
        case .nesGame:
            return "srm"
        }
    }
    
    var supportedSaveFiles: [ArcadiaCoreMemoryType : String] {
        switch self {
        case .gameBoyAdvanceGame:
            return [
                .memorySaveRam : "srm"
            ]
        case .gameBoyGame:
            return [
                .memorySaveRam : "srm",
                .memoryRTC : "rtc"
            ]
        case.nesGame:
            return [
                .memorySaveRam : "srm"
            ]
        }
    }
    
    var defaultCollectionImage: Image {
        switch self {
        case .gameBoyAdvanceGame:
            return Image("gba_icon")
        case .gameBoyGame:
            return Image("gbc_icon")
        case .nesGame:
            return Image("nes_icon")
        }
    }
    
    //TODO: Fix this not being able to be called from the view
    @ViewBuilder var portraitButtonLayout: some View {
        switch self {
        case .gameBoyAdvanceGame:
            GBAButtonLayout()
        case .gameBoyGame:
            GBCButtonLayout()
        case .nesGame:
            GBCButtonLayout()
        }
    }
    
    var getSaveDirectory: URL {
        return ArcadiaFileManager.shared.getSaveDirectory(for: self)
    }
    
    var getStateDirectory: URL {
        return ArcadiaFileManager.shared.getStateDirectory(for: self)
    }
    
    var getImageDirectory: URL {
        return ArcadiaFileManager.shared.getImageDirectory(for: self)
    }
    
    var getCoreDirectory: URL {
        return ArcadiaFileManager.shared.getCoreDirectory(for: self)
    }

}
