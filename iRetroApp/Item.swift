//
//  Item.swift
//  iRetroApp
//
//  Created by Davide Andreoli on 01/05/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
