//
//  Item.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/12/25.
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
