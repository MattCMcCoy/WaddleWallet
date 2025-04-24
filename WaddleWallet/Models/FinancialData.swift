//
//  FinancialData.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/18/25.
//

import Foundation
import SwiftData

struct FinancialData: Identifiable {
    let id = UUID()
    let date: Date
    let asset: Double
    let debt: Double

    var netAsset: Double {
        asset - debt
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d" // e.g., "Apr 13"
        return formatter.string(from: date)
    }
}
