//
//  Account.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import Foundation
import SwiftData

enum AccountType: String, Codable {
    case checking
    case savings
    case credit
    case investment
}

@Model
final class Account {
    var id: UUID
    var bank: String
    var name: String
    var balance: Double
    var accountType: AccountType
    var transactions: [Transaction]

    init(bank: String, name: String, balance: Double, accountType: AccountType, transactions: [Transaction] = []) {
        id = UUID() // Initialize the UUID
        self.bank = bank
        self.name = name
        self.balance = balance
        self.accountType = accountType
        self.transactions = transactions
    }
    
    
    static let sampleData: [Account] = [
        Account(bank: "Chase", name: "Checking", balance: 1450.32, accountType: AccountType.checking),
        Account(bank: "Bank of America", name: "Savings", balance: 8500.00, accountType: AccountType.savings),
        Account(bank: "Ally", name: "High Yield Savings", balance: 12200.75, accountType: AccountType.savings),
        Account(bank: "Wells Fargo", name: "Everyday Checking", balance: 320.60, accountType: AccountType.checking),
        Account(bank: "Capital One", name: "360 Checking", balance: 2189.45, accountType: AccountType.checking),
        Account(bank: "Discover", name: "Online Savings", balance: 5000.00, accountType: AccountType.savings),
        Account(bank: "Local Credit Union", name: "Joint Account", balance: 1380.22, accountType: AccountType.credit),
        Account(bank: "Chime", name: "Spending Account", balance: 774.93, accountType: AccountType.credit),
        Account(bank: "SoFi", name: "Money Account", balance: 2899.99, accountType: AccountType.investment),
        Account(bank: "Revolut", name: "Main Account", balance: 410.75, accountType: AccountType.investment)
    ]
}
