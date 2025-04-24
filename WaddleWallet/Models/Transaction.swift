//
//  Transaction.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import Foundation
import SwiftData

enum TransactionType: String, Codable {
    case income
    case expense
    case transfer
}

@Model
final class Transaction: Identifiable {
    var id: UUID
    var date: Date
    var amount: Double
    var transactionType: TransactionType?
    var category: Category?
    var note: String?

    @Relationship var account: Account?

    init(amount: Double, date: Date, transactionType: TransactionType, note: String? = nil, category: Category? = nil, account: Account? = nil) {
        id = UUID()
        self.amount = amount
        self.date = date
        self.note = note
        self.transactionType = transactionType

        self.category = category
        self.account = account
    }
}
