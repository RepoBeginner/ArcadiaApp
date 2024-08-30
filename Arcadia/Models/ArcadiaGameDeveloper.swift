//
//  ArcadiaGameDeveloper.swift
//  Arcadia
//
//  Created by Davide Andreoli on 30/08/24.
//

import Foundation

struct ArcadiaGameDeveloper: Hashable, Codable {
    
    let id: Int
    let name: String
    let bio: String
    
    let instagramURL: URL?
    let itchURL: URL?
    let threadsURL: URL?
    let twitterURL: URL?
    
    init(id: Int, name: String, bio: String, instagramURL: URL?, itchURL: URL?, threadsURL: URL?, twitterURL: URL?) {
        self.id = id
        self.name = name
        self.bio = bio
        self.instagramURL = instagramURL
        self.itchURL = itchURL
        self.threadsURL = threadsURL
        self.twitterURL = twitterURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, bio, instagramURL, itchURL, threadsURL, twitterURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        bio = try container.decode(String.self, forKey: .bio)
        
        let itchURLString = try container.decode(String.self, forKey: .itchURL)
        itchURL = URL(string: itchURLString)
        
        let instagramURLString = try container.decode(String.self, forKey: .instagramURL)
        instagramURL = URL(string: instagramURLString)
        
        let threadsURLString = try container.decode(String.self, forKey: .threadsURL)
        threadsURL = URL(string: threadsURLString)
        
        let twitterURLString = try container.decode(String.self, forKey: .twitterURL)
        twitterURL = URL(string: twitterURLString)
        
    }
}
