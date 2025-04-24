//
//  Dashboard.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import SwiftData
import SwiftUI

struct Dashboard: View {
    @Query(sort: \Account.name) private var accounts: [Account]
    @Environment(\.modelContext) private var context

    var dataFromAccounts: SankeyData {
        var nodesSet: Set<String> = []
        var nodes: [SankeyNode] = []
        var links: [SankeyLink] = []
        var income = 0.0

        for account in accounts {
            for transaction in account.transactions {
                guard let transactionType = transaction.transactionType else { continue }

                if transactionType != .income { continue }

                income += transaction.amount
            }
        }

        let incomeLabel = "Income"
        let incomeNode = SankeyNode(name: incomeLabel, color: .gray)
        nodes.append(incomeNode)
        nodesSet.insert(incomeLabel)

        for account in accounts {
            for transaction in account.transactions {
                guard let category = transaction.category else { continue }

                let categoryLabel = category.name
                let amount = abs(transaction.amount)

                var categoryNode: SankeyNode? = nil
                if !nodesSet.contains(categoryLabel) {
                    categoryNode = SankeyNode(name: categoryLabel, color: category.color)
                    nodes.append(categoryNode!)
                    nodesSet.insert(categoryLabel)
                }
                else {
                    continue
                }
                
                links.append(SankeyLink(from: incomeNode, to: categoryNode!, amount: amount))
            }
        }

        let leftoverLabel = "Not Yet Categorized"
        var leftover: Double = income
        let leftoverNode = SankeyNode(name: leftoverLabel, color: .gray)
        nodes.append(leftoverNode)

        for link in links {
            leftover -= link.amount
        }

        links.append(SankeyLink(from: incomeNode, to: leftoverNode, amount: leftover))

        return SankeyData(nodes: nodes, links: links)
    }

    var body: some View {
        HStack {
                if accounts.isEmpty {
                    Text("No transactions yet.")
                } else {
                    Spacer()
                    GeometryReader { geometry in
                        VStack {
                            Text("Spending by Category")
                                .font(.title3)
                                .fontWeight(.bold)
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2)
                                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width)
                                    
                                    SankeyCanvas()
                                        .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                                }
                                
                                Spacer()
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}

#Preview {
    Dashboard()
        .modelContainer(SampleData.shared.modelContainer)
}

