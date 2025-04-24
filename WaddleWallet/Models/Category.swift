//
//  Category.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/7/25.
//
import SwiftData
import SwiftUI

@Model
class Category {
    var name: String
    var colorHex: String // Stored in SwiftData

    init(name: String, color: Color) {
        self.name = name
        colorHex = color.toHex() ?? "#000000"
    }

    var color: Color {
        get { Color(hex: colorHex) }
        set { colorHex = newValue.toHex() ?? "#000000" }
    }
}

extension Color {
    func toHex() -> String? {
        #if os(iOS)
            let uiColor = UIColor(self)
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                return nil
            }
            return String(format: "#%02X%02X%02X",
                          Int(red * 255), Int(green * 255), Int(blue * 255))
        #else
            return nil
        #endif
    }

    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.index(hex.startIndex, offsetBy: 1)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
