//
//  Transaction.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var amount: Double
    var date: Date
    var category: String

    init(amount: Double, date: Date, category: String = "") {
        id = UUID()
        self.amount = amount
        self.date = date
        self.category = category
    }
}
