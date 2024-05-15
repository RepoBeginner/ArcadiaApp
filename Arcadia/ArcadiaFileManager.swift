//
//  iRetroFileManager.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 07/05/24.
//

import Foundation

@Observable class ArcadiaFileManager {
    
    
    var documentsDirectory: URL
    var gbGameDirectory: URL
    var gbGames: [URL] {
        do {
            let test = try FileManager.default.contentsOfDirectory(at: self.gbGameDirectory, includingPropertiesForKeys: nil)
            return test
        }
        catch {
            return []
        }
    }
    
    init() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.documentsDirectory = documentDirectory
        
        let gbGameDirectory = documentDirectory.appendingPathComponent("GB")
        self.gbGameDirectory = gbGameDirectory
        
    }
    
}
