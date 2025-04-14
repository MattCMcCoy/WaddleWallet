//
//  Profile.swift
//  WaddleWallet
//
//  Created by Matt McCoy on 4/9/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Profile {
    var Accounts: [Account] = []

    init(accounts: [Account] = []) {
        Accounts = accounts
    }
}
