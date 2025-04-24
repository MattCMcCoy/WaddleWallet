//
//  PreviewProvider.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/22/25.
//
import SwiftUI

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone Preview
            ContentView()
                .modelContainer(SampleData.shared.modelContainer)
                .previewDevice("iPhone 16 Pro")
                .previewDisplayName("iPhone 16 Pro")

            // iPad Preview
            ContentView()
                .previewDevice("iPad Pro 13-inch (M4)")
                .previewLayout(.device)
                .modelContainer(SampleData.shared.modelContainer)
                .previewDisplayName("iPad Pro 13-inch (M4)")

            // Dark Mode Preview
            ContentView()
                .modelContainer(SampleData.shared.modelContainer)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
