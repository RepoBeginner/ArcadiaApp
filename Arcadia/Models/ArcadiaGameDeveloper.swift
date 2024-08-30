//
//  ArcadiaGameDeveloper.swift
//  Arcadia
//
//  Created by Davide Andreoli on 30/08/24.
//

import Foundation

struct ArcadiaGameDeveloper: Hashable, Decodable {
    
    let id: Int
    let name: String
    let bio: String
    
    let socials: [ArcadiaDeveloperSocialLink]
    
    init(id: Int, name: String, bio: String, socials: [ArcadiaDeveloperSocialLink]) {
        self.id = id
        self.name = name
        self.bio = bio
        self.socials = socials
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, bio, socials
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        bio = try container.decode(String.self, forKey: .bio)
        
        let socialsArray = try container.decode([[String : String]].self, forKey: .socials)
        var socialsList = [ArcadiaDeveloperSocialLink]()
        for social in socialsArray {
            socialsList.append(ArcadiaDeveloperSocialLink(name: social["name"]!, link: URL(string: social["URL"]!)))
        }
        socials = socialsList
        
    }
}
