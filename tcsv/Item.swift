//
//  Item.swift
//  tcsv
//
//  Created by Serdar Senol on 04/07/2025.
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
