//
//  Item.swift
//  ProxiChat
//
//  Created by Tarun Chinthakindi on 25/05/24.
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
