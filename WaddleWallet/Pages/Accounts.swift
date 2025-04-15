//
//  Accounts.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import Charts
import SwiftData
import SwiftUI

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

struct Accounts: View {
    @State private var rawSelectedDate: Date? = nil
    @State private var showNetAssets = true
    @State private var showChartTogglePopup = false
    
    let data: [FinancialData] = [
        FinancialData(date: .now.addingTimeInterval(-86400 * 9), asset: 8500, debt: 2800),
        FinancialData(date: .now.addingTimeInterval(-86400 * 8), asset: 9000, debt: 2900),
        FinancialData(date: .now.addingTimeInterval(-86400 * 7), asset: 9500, debt: 2950),
        FinancialData(date: .now.addingTimeInterval(-86400 * 6), asset: 9800, debt: 3000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 5), asset: 10000, debt: 3100),
        FinancialData(date: .now.addingTimeInterval(-86400 * 4), asset: 10500, debt: 3200),
        FinancialData(date: .now.addingTimeInterval(-86400 * 3), asset: 12000, debt: 3500),
        FinancialData(date: .now.addingTimeInterval(-86400 * 2), asset: 12500, debt: 4000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 1), asset: 13000, debt: 4200),
        FinancialData(date: .now, asset: 90000, debt: 4500),
    ]
    
    let data2: [FinancialData] = [
        FinancialData(date: .now.addingTimeInterval(-86400 * 9), asset: 8500, debt: 20000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 8), asset: 9000, debt: 30000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 7), asset: 9500, debt: 40000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 6), asset: 9800, debt: 60000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 5), asset: 10000, debt: 45000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 4), asset: 10500, debt: 30000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 3), asset: 12000, debt: 20000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 2), asset: 12500, debt: 15000),
        FinancialData(date: .now.addingTimeInterval(-86400 * 1), asset: 13000, debt: 10000),
        FinancialData(date: .now, asset: 90000, debt: 5000),
    ]

    @State private var isExpanded = false

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
                .annotation(
                    position: .top,
                    spacing: 0,
                    overflowResolution: .init(
                        x: .fit(to: .chart),
                        y: .disabled
                    )
                ) {
                    valueSelectionPopover(selected: selected)
                }
        }
    }
    
    @ViewBuilder
    var AssetsToDebtText: some View {
        Group{
            HStack {
                Text("Assets:\n$\(String(format: "%.2f", (selectedData ?? data.last!).asset))")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.trailing)
                Text("Debt:\n$\(String(format: "%.2f", (selectedData ?? data.last!).debt))")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.leading)
            }
        }
    }
    
    @ViewBuilder
    var assetDebtLinesChart: some View {
        Chart {
            ForEach(data) { element in
                LineMark(
                    x: .value("Date", element.date),
                    y: .value("Asset", element.asset)
                )
                .foregroundStyle(by: .value("Type", "Assets"))
            }
            
            ForEach(data2) { element in
                LineMark(
                    x: .value("Date", element.date),
                    y: .value("Debt", element.debt)
                )
                .foregroundStyle(by: .value("Type", "Debt"))
            }
            
            selectionMark
        }
    }
    
    @ViewBuilder
    var netAssetChart: some View {
        Chart {
            ForEach(data) { element in
                LineMark(
                    x: .value("Date", element.date),
                    y: .value("Net Assets", element.netAsset)
                )
                .foregroundStyle(.green)
            }
            selectionMark
        }
    }

    var body: some View {
        VStack {
            VStack {
                Group {
                    AssetsToDebtText
                }
                .padding()
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if showNetAssets {
                            netAssetChart
                        } else {
                            assetDebtLinesChart
                            .chartForegroundStyleScale([
                                "Assets": .blue,
                                "Debt": .red
                            ])
                        }
                    }
                    .chartXSelection(value: $rawSelectedDate)
                    .frame(width: 300, height: 100)
                    .padding(30)
                    .chartXAxis {}
                    .chartYAxis {}
                    
                    // Toggle button (bottom right)
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
                    .padding(10)
                }
            }
            Divider()

            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("Credit Cards")
                            .font(.headline)
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Account 1: $1,200")
                        Text("• Account 2: $850")
                        Text("• Account 3: $3,000")
                    }
                    .padding(.top, 8)
                    .transition(.opacity)
                }
            }
            .padding()
            .animation(.easeInOut, value: isExpanded)

            Spacer()
            // Popup view
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
    }
    
    @ChartContentBuilder
    private func assetChartLines() -> some ChartContent {
        ForEach(data) { element in
            LineMark(
                x: .value("Date", element.date),
                y: .value("Value", element.asset)
            )
            .foregroundStyle(by: .value("Type", "Assets"))
        }
    }

    @ChartContentBuilder
    private func debtChartLines() -> some ChartContent {
        ForEach(data2) { element in
            LineMark(
                x: .value("Date", element.date),
                y: .value("Value", element.debt)
            )
            .foregroundStyle(by: .value("Type", "Debt"))
        }
    }



    @ViewBuilder
    private func valueSelectionPopover(selected: FinancialData) -> some View {
        HStack {
            Text("\(selected.formattedDate)")
                .font(.caption)
                .foregroundColor(.blue)
        }
    }

    func addAccount() {}
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
