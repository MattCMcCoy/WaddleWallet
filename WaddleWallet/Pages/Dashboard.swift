//
//  Dashboard.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import Charts
import SwiftData
import SwiftUI

struct Dashboard: View {
    struct ProfitOverTime {
        var date: Date
        var profit: Double
    }

    let departmentAProfit: [ProfitOverTime] = [ProfitOverTime(date: Date.now, profit: 20), ProfitOverTime(date: Date.now + 1, profit: 10000)]

    let departmentBProfit: [ProfitOverTime] = [ProfitOverTime(date: Date.now, profit: 20), ProfitOverTime(date: Date.now + 1, profit: 400)]

    var body: some View {
        Chart {
            ForEach(departmentAProfit, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Profit A", item.profit),
                    series: .value("Company", "A")
                )
                .foregroundStyle(.green)
            }
            ForEach(departmentBProfit, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Profit B", item.profit),
                    series: .value("Company", "B")
                )
                .foregroundStyle(.orange)
            }
        }
        .frame(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
        Text("Credit Cards")
            .font(.body)
            .fontWeight(.light)
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.leading)
            .padding(/*@START_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
