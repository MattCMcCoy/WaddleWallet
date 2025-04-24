//
//  TransactionExtensions.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/18/25.
//
import Foundation
import SwiftData
import SwiftUI

extension [Transaction] {
    func totalBalance() -> Double {
        self.reduce(0) { $0 + $1.amount }
    }

    func balanceTimeline() -> [(date: Date, balance: Double)] {
        let sorted = self.sorted(by: { $0.date < $1.date })
        var result: [(Date, Double)] = []
        var runningTotal = 0.0

        for transaction in sorted {
            runningTotal += transaction.amount
            result.append((transaction.date, runningTotal))
        }
        return result
    }
}

extension [Account] {
    func generateFinancialData() -> [FinancialData] {
        let accounts = self.sorted(by: { $0.name < $1.name })
        let calendar = Calendar.current
        var allTransactions: [(date: Date, amount: Double, account: Account)] = []

        // Flatten transactions and normalize dates
        for account in accounts {
            for transaction in account.transactions {
                let cleanDate = calendar.startOfDay(for: transaction.date)
                allTransactions.append((date: cleanDate, amount: transaction.amount, account: account))
            }
        }

        // Group transactions by date
        let groupedByDate = Dictionary(grouping: allTransactions, by: { $0.date })
        let sortedDates = groupedByDate.keys.sorted()

        // Start with actual account balances
        var runningBalances: [UUID: Double] = [:]
        for account in accounts {
            runningBalances[account.id] = account.balance
        }

        var financialTimeline: [FinancialData] = []

        // Reverse sort so we work backwards from current balance
        for date in sortedDates.reversed() {
            if let transactions = groupedByDate[date] {
                for tx in transactions {
                    runningBalances[tx.account.id, default: 0] -= tx.amount
                }
            }

            var assetTotal: Double = 0
            var debtTotal: Double = 0

            for account in accounts {
                let balance = runningBalances[account.id, default: 0]

                switch account.accountType {
                case .credit:
                    debtTotal += Swift.max(balance, 0)
                default:
                    assetTotal += balance
                }
            }

            let dataPoint = FinancialData(date: date, asset: assetTotal, debt: debtTotal)
            financialTimeline.append(dataPoint)
        }

        return financialTimeline.sorted(by: { $0.date < $1.date })
    }
}
