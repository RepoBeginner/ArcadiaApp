//
//  ArcadiaDeveloperSocialLink.swift
//  Arcadia
//
//  Created by Davide Andreoli on 30/08/24.
//

import Foundation

struct ArcadiaDeveloperSocialLink: Hashable {
    
    let name: String
    let link: URL?
    
    var blackLogoAssetName: String {
        return "\(name)LogoBlack"
    }
    
    var whiteLogoAssetName: String {
        return "\(name)LogoWhite"
    }
    
}
