//
//  Transactions.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/18/25.
//

import SwiftData
import SwiftUI

struct Transactions: View {
    @Query(sort: \Account.name) private var accounts: [Account]
    @Environment(\.modelContext) private var context
    
    
    
    var body: some View {
        
        VStack {
            if accounts.isEmpty {
                Text("No transactions yet.")
            } else {
                VStack(alignment: .leading) {
                    ForEach(accounts) { account in
                        ForEach(account.transactions) { transaction in
                            HStack {
                                Text(transaction.note ?? "")
                                    .foregroundColor(Color.red)
                                Text(transaction.amount.description)
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                }
                .padding(10)
                .frame(height: 350)
            }
            
            Spacer()
        }
    }
}

#Preview {
    Transactions()
        .modelContainer(SampleData.shared.modelContainer)
}
