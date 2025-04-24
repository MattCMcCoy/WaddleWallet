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
final class Account: Identifiable {
    var id: UUID
    var bank: String
    var name: String
    var balance: Double
    var accountType: AccountType
    
    @Relationship var transactions: [Transaction]

    init(bank: String, name: String, balance: Double, accountType: AccountType, transactions: [Transaction] = []) {
        id = UUID() // Initialize the UUID
        self.bank = bank
        self.name = name
        self.balance = balance
        self.accountType = accountType
        self.transactions = transactions
    }

    static let sampleData: [Account] = {
        let c1 = Category(name: "Groceries", color: .green)
        let c2 = Category(name: "Utilities", color: .blue)
        let c3 = Category(name: "Entertainment", color: .purple)
        let c4 = Category(name: "Transport", color: .orange)
        let c5 = Category(name: "Health", color: .red)

        let chase = Account(bank: "Chase", name: "Checking", balance: 1450.32, accountType: .checking)
        chase.transactions = [
            Transaction(amount: 2500.00, date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!, transactionType: .income, note: "Paycheck", account: chase),
            Transaction(amount: -1200.00, date: Calendar.current.date(byAdding: .day, value: -12, to: Date())!, transactionType: .expense, note: "Rent", category: c2, account: chase),
            Transaction(amount: -50.00, date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, transactionType: .expense, note: "Groceries", category: c1, account: chase),
        ]

        let bofa = Account(bank: "Bank of America", name: "Savings", balance: 8500.00, accountType: .savings)
        bofa.transactions = [
            Transaction(amount: 1000.00, date: Calendar.current.date(byAdding: .day, value: -30, to: Date())!, transactionType: .transfer, note: "Transfer In", account: bofa),
        ]

        let creditUnion = Account(bank: "Local Credit Union", name: "Joint Account", balance: 1380.22, accountType: .credit)
        creditUnion.transactions = [
            Transaction(amount: -500.00, date: Calendar.current.date(byAdding: .day, value: -20, to: Date())!, transactionType: .expense, note: "Car Repair", category: c4, account: creditUnion),
            Transaction(amount: -300.00, date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!, transactionType: .expense, note: "Furniture", category: c3, account: creditUnion),
            Transaction(amount: 200.00, date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, transactionType: .income, note: "Payment", account: creditUnion),
        ]

        let chime = Account(bank: "Chime", name: "Spending Account", balance: 774.93, accountType: .credit)
        chime.transactions = [
            Transaction(amount: -150.00, date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, transactionType: .expense, note: "Online Shopping", category: c3, account: chime),
            Transaction(amount: -60.00, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, transactionType: .expense, note: "Gas", category: c4, account: chime),
            Transaction(amount: 100.00, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, transactionType: .income, note: "Payment", account: chime),
        ]

        return [
            chase,
            bofa,
            creditUnion,
            chime,
            Account(bank: "SoFi", name: "Money Account", balance: 2899.99, accountType: .investment),
            Account(bank: "Revolut", name: "Main Account", balance: 410.75, accountType: .investment),
        ]
    }()
}
