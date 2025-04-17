//
//  Accounts.CategorySection.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/17/25.
//
import SwiftData
import SwiftUI

struct AccountCategorySection: View {
    let title: String
    let accounts: [Account]
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
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
                    ForEach(accounts) { account in
                        HStack {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                                    .frame(width: 200, height: 100)

                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(account.bank)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top, 5)
                                        Spacer()
                                    }
                                    .padding(.leading, 5)

                                    Spacer()

                                    Text(account.name)
                                        .foregroundColor(.white)
                                        .padding(8)
                                }
                                .frame(width: 200, height: 100)
                            }

                            VStack {
                                Text("Available Funds")
                                    .font(.footnote)
                                    .fontWeight(.thin)
                                    .foregroundColor(.gray)

                                Text(account.balance.currencyFormatted)
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    Accounts()
        .modelContainer(SampleData.shared.modelContainer)
}
