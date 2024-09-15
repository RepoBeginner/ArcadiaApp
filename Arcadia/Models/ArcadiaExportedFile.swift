//
//  ArcadiaExportedFile.swift
//  Arcadia
//
//  Created by Davide Andreoli on 13/09/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ArcadiaExportedFile: FileDocument {
    
    static var readableContentTypes = [
        UTType(importedAs: "com.davideandreoli.Arcadia.saveFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.atari2600GameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.genesisGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.megaDriveGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.gameGearGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.masterSystemGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.neoGeoPocketGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.atari7800GameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.snesGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.nesGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.gameBoyAdvanceGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.gameBoyGameFile")
    ]
    
    static var writableContentTypes: [UTType] = [
        UTType(importedAs: "com.davideandreoli.Arcadia.saveFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.atari2600GameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.genesisGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.megaDriveGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.gameGearGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.masterSystemGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.neoGeoPocketGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.atari7800GameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.snesGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.nesGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.gameBoyAdvanceGameFile"),
        UTType(importedAs: "com.davideandreoli.Arcadia.gameBoyGameFile")
    ]
    
    var data = Data()
    
    init(initialData: Data = Data()) {
        self.data = initialData
    }

    init(fileURL: URL) {
        do {
            self.data = try Data(contentsOf: fileURL)
        } catch {
            self.data = Data()
        }
        
    }
    
    init(configuration: ReadConfiguration) throws {
        if let fileData = configuration.file.regularFileContents {
            self.data = fileData
        } else {
            self.data = Data()
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        print(configuration.contentType)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        // fileWrapper.preferredFilename = "document.\(ext)"
        return fileWrapper
    }
    
}

