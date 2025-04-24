//
//  TabModel.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/12/25.
//

import SwiftUI

struct TabModel: Identifiable {
    let id: Tab
    var size: CGSize = .zero
    var minX: CGFloat = .zero

    enum Tab: CaseIterable, Identifiable {
        case accounts, transactions, dashboard, budget

        var id: Self { self }

        @ViewBuilder
        var view: some View {
            switch self {
            case .accounts:
                Accounts()
            case .transactions:
                Transactions()
            case .dashboard:
                Dashboard()
            case .budget:
                Budget()
            }
        }

        var title: String {
            switch self {
            case .accounts: return "Accounts"
            case .transactions: return "Transactions"
            case .dashboard: return "Dashboard"
            case .budget: return "Budget"
            }
        }

        var icon: String {
            switch self {
            case .accounts: return "person.circle"
            case .transactions: return "list.bullet"
            case .dashboard: return "chart.bar.fill"
            case .budget: return "calendar"
            }
        }
    }
}
