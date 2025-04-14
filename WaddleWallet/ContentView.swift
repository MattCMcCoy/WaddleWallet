//
//  ContentView.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var accounts: [Account]

    @State private var tabs: [TabModel] = TabModel.Tab.allCases.map { TabModel(id: $0) }
    @State private var activeTab: TabModel.Tab? = .accounts
    @State private var mainViewScrollState: TabModel.Tab? = nil
    @State private var tabBarScrollState: TabModel.Tab? = nil

    var body: some View {
        #if os(iOS)
            VStack {
                HeaderView()
                HorizontalTabBar()

                GeometryReader { proxy in
                    let size = proxy.size

                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            ForEach(tabs) { tab in
                                tab.id.view
                                    .padding(.horizontal, 16)
                                    .frame(width: size.width, height: size.height)
                                    .clipped()
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollPosition(id: $mainViewScrollState)
                    .onChange(of: mainViewScrollState) {
                        activeTab = mainViewScrollState
                        tabBarScrollState = mainViewScrollState
                    }
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                }
            }
        #endif

        #if os(macOS)
            NavigationSplitView {
                List {
                    ForEach(tabs) { tab in
                        NavigationLink {
                            tab.id.view
                                .padding(.horizontal, 16)
                                .clipped()
                        } label: {
                            Label(tab.id.title, systemImage: tab.id.icon)
                        }
                    }

                    Divider()
                    Text("My Accounts")
                        .font(.caption)
                        .fontWeight(.black)
                        .foregroundColor(.gray)

                    ForEach(accounts) { account in
                        NavigationLink {
                            Text("Item at \(account.bank)")
                        } label: {
                            Text(account.bank)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .toolbar {
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Account", systemImage: "plus")
                        }
                    }
                }
            } detail: {
                Text("Select an account")
            }
        #endif
    }

    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Image(.logo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 50)
        }
    }

    @ViewBuilder
    private func HorizontalTabBar() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(tabs) { tab in
                    Button(action: {
                        withAnimation(.snappy) {
                            activeTab = tab.id
                            tabBarScrollState = tab.id
                            mainViewScrollState = tab.id
                        }
                    }) {
                        Text(tab.id.title)
                            .fontWeight(.medium)
                            .foregroundColor(activeTab == tab.id ? .white : .blue)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(activeTab == tab.id ? Color.blue : Color.clear)
                            )
                    }
                    .id(tab.id)
                }
            }
            .padding(.horizontal, 5)
            .scrollTargetLayout()
        }
        .scrollPosition(
            id: .init(get: { tabBarScrollState }, set: { _ in }),
            anchor: .center
        )
    }

    private func addItem() {
        withAnimation {
            let newAccount = Account(bank: "BofA", name: "Checking", balance: 1234.56)
            modelContext.insert(newAccount)
            try? modelContext.save()
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            for offset in offsets {
                modelContext.delete(accounts[offset])
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Account.self, inMemory: true)
}
