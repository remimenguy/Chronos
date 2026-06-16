//
//  Item.swift
//  Chronos
//
//  Created by Rémi Menguy on 16/06/2026.
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
