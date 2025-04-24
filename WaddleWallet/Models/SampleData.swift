//
//  SampleData.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/16/25.
//

import Foundation
import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()

    let modelContainer: ModelContainer

    var context: ModelContext {
        modelContainer.mainContext
    }

    private init() {
        let schema = Schema([
            Account.self,
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            insertSampleData()
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private func insertSampleData() {
        for account in Account.sampleData {
            context.insert(account)
        }
    }
}
