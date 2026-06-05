//
//  Item.swift
//  NailongPet
//
//  Created by Fakhri Djamaris on 05/06/26.
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
