//
//  ArcadiaSaveFile.swift
//  Arcadia
//
//  Created by Davide Andreoli on 13/09/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ArcadiaSaveFile: FileDocument {
    
    static var readableContentTypes = [UTType(importedAs: "com.davideandreoli.Arcadia.saveFile")]
    
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
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        // fileWrapper.preferredFilename = "document.\(ext)"
        return fileWrapper
    }
    
}
