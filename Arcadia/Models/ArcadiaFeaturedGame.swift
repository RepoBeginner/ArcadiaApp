//
//  ArcadiaFeaturedGame.swift
//  Arcadia
//
//  Created by Davide Andreoli on 30/08/24.
//

import Foundation

struct ArcadiaFeaturedGame: Hashable, Codable {
    
    let id: Int
    let name: String
    let shortDescription: String
    let longDescription: String
    let developerId: Int
    let coverImageAssetName: String
    let itchURL: URL?
    let screenshotsAssetName: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, shortDescription, longDescription, developerId, coverImageAssetName, itchURL, screenshotsAssetName
    }
    
    init(id: Int, name: String, shortDescription: String, longDescription: String, developerId: Int, coverImageAssetName: String, itchURL: URL?, screenshotsAssetName: [String]) {
        self.id = id
        self.name = name
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.developerId = developerId
        self.coverImageAssetName = coverImageAssetName
        self.itchURL = itchURL
        self.screenshotsAssetName = screenshotsAssetName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        shortDescription = try container.decode(String.self, forKey: .shortDescription)
        longDescription = try container.decode(String.self, forKey: .longDescription)
        developerId = try container.decode(Int.self, forKey: .developerId)
        coverImageAssetName = try container.decode(String.self, forKey: .coverImageAssetName)
        
        let itchURLString = try container.decode(String.self, forKey: .itchURL)
        itchURL = URL(string: itchURLString)
        
        screenshotsAssetName = try container.decode([String].self, forKey: .screenshotsAssetName)
    }
    
}
