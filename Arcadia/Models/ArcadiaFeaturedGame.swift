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
    let bundledFileExtension: String
    let gameType: ArcadiaGameType
    let shortDescription: String
    let longDescription: String
    let genres: [String]
    let developerId: Int
    let coverImageAssetName: String
    let itchURL: URL?
    let githubURL: URL?
    let screenshotsAssetName: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, bundledFileExtension, gameType, shortDescription, genres, longDescription, developerId, coverImageAssetName, itchURL, githubURL, screenshotsAssetName
    }
    
    init(id: Int, name: String, bundledFileExtension: String, gameType: ArcadiaGameType, shortDescription: String, genres: [String], longDescription: String, developerId: Int, coverImageAssetName: String, itchURL: URL?, githubURL: URL?, screenshotsAssetName: [String]) {
        self.id = id
        self.name = name
        self.bundledFileExtension = bundledFileExtension
        self.gameType = gameType
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.genres = genres
        self.developerId = developerId
        self.coverImageAssetName = coverImageAssetName
        self.itchURL = itchURL
        self.githubURL = githubURL
        self.screenshotsAssetName = screenshotsAssetName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        bundledFileExtension = try container.decode(String.self, forKey: .bundledFileExtension)
        shortDescription = try container.decode(String.self, forKey: .shortDescription)
        longDescription = try container.decode(String.self, forKey: .longDescription)
        developerId = try container.decode(Int.self, forKey: .developerId)
        coverImageAssetName = try container.decode(String.self, forKey: .coverImageAssetName)
        genres = try container.decode([String].self, forKey: .genres)
        
        let gameTypeString = try container.decode(String.self, forKey: .gameType)
        gameType = ArcadiaGameType(rawValue: gameTypeString)!
        
        let itchURLString = try container.decode(String.self, forKey: .itchURL)
        itchURL = URL(string: itchURLString)
        
        let githubURLString = try container.decode(String.self, forKey: .githubURL)
        githubURL = URL(string: githubURLString)
        
        screenshotsAssetName = try container.decode([String].self, forKey: .screenshotsAssetName)
    }
    
}
