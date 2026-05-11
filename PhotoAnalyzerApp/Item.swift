//
//  Item.swift
//  PhotoAnalyzerApp
//
//  Created by ikorobov on 11. 5. 2026..
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
