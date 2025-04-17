//
//  CurrencyExtensions.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/16/25.
//
import Foundation

extension Double {
    var currencyFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
