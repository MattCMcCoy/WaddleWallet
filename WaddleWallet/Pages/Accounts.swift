//
//  Accounts.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import Charts
import SwiftData
import SwiftUI

struct Accounts: View {
    @Query(sort: \Account.name) private var accounts: [Account]
    @Environment(\.modelContext) private var context

    @State private var rawSelectedDate: Date? = nil
    @State private var showNetAssets = true
    @State private var showChartTogglePopup = false
    @State private var isExpanded = false

    private let accountCategories: [(title: String, types: [AccountType])] = [
        ("Credit Cards", [.credit]),
        ("Checking & Savings", [.checking, .savings]),
        ("Investments", [.investment]),
    ]

    var data: [FinancialData] {
        accounts.generateFinancialData()
    }

    var selectedData: FinancialData? {
        guard let rawSelectedDate else { return nil }
        return data.min(by: {
            abs($0.date.timeIntervalSince1970 - rawSelectedDate.timeIntervalSince1970) <
                abs($1.date.timeIntervalSince1970 - rawSelectedDate.timeIntervalSince1970)
        })
    }

    @ChartContentBuilder
    var selectionMark: some ChartContent {
        if let selected = selectedData {
            RuleMark(x: .value("Selected", selected.date))
                .foregroundStyle(Color.gray.opacity(0.3))
                .offset(yStart: -10)
                .zIndex(-1)
                .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                    valueSelectionPopover(selected: selected)
                }
        }
    }

    @ViewBuilder
    private var chartToggleButton: some View {
        if showChartTogglePopup {
            Button(action: {
                showNetAssets.toggle()
                showChartTogglePopup = false
            }) {
                HStack(spacing: 8) {
                    Image(systemName: showNetAssets ? "chart.bar.xaxis" : "chart.line.uptrend.xyaxis")
                    Text(showNetAssets ? "Show Assets vs Debt" : "Show Net Assets")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                .shadow(radius: 4)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .padding(.bottom, 60)
        }
    }

    var assetsToDebtText: some View {
        let selected = selectedData ?? data.last!
        let values: [(String, Double)] = [
            ("Assets", selected.asset),
            ("Debt", selected.debt),
        ]

        return HStack {
            ForEach(values, id: \.0) { label, value in
                Text("\(label):\n$\(String(format: "%.2f", value))")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    var assetDebtLinesChart: some View {
        Chart {
            assetChartLines()
            debtChartLines()
            selectionMark
        }
        .chartForegroundStyleScale(["Assets": .blue, "Debt": .red])
    }

    @ChartContentBuilder
    private func assetChartLines() -> some ChartContent {
        ForEach(data) {
            LineMark(x: .value("Date", $0.date), y: .value("Value", $0.asset))
                .foregroundStyle(by: .value("Type", "Assets"))
        }
    }

    @ChartContentBuilder
    private func debtChartLines() -> some ChartContent {
        ForEach(data) {
            LineMark(x: .value("Date", $0.date), y: .value("Value", $0.debt))
                .foregroundStyle(by: .value("Type", "Debt"))
        }
    }

    private func valueSelectionPopover(selected: FinancialData) -> some View {
        Text("\(selected.formattedDate)")
            .font(.caption)
            .foregroundColor(.blue)
    }

    var netAssetChart: some View {
        Chart {
            ForEach(data) {
                LineMark(x: .value("Date", $0.date), y: .value("Net Assets", $0.netAsset))
                    .foregroundStyle(.green)
            }
            selectionMark
        }
    }

    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    assetsToDebtText
                        .padding()
                    Group {
                        if showNetAssets {
                            netAssetChart
                        } else {
                            assetDebtLinesChart
                        }
                    }
                    .chartXSelection(value: $rawSelectedDate)
                    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3)
                    .chartXAxis {}
                    .chartYAxis {}
                    
                    Button(action: {
                        withAnimation {
                            showChartTogglePopup.toggle()
                        }
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)

            Divider()

            ScrollView {
                ForEach(accountCategories, id: \.types) { category in
                    AccountCategorySection(
                        title: category.title,
                        accounts: accounts.filter { category.types.contains($0.accountType) }
                    )
                }
            }
            .scrollIndicators(.hidden)

            Spacer()
            chartToggleButton
        }
    }
}

#Preview {
    Accounts()
        .modelContainer(SampleData.shared.modelContainer)
}


#Preview {
    ContentView()
        .modelContainer(SampleData.shared.modelContainer)
}
