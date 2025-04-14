//
//  Account.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import Foundation
import SwiftData

@Model
final class Account {
    var id: UUID
    var bank: String
    var name: String
    var balance: Double
    var transactions: [Transaction]

    init(bank: String, name: String, balance: Double, transactions: [Transaction] = []) {
        id = UUID() // Initialize the UUID
        self.bank = bank
        self.name = name
        self.balance = balance
        self.transactions = transactions
    }
}
