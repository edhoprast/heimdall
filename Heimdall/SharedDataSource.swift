//
//  SharedDataSource.swift
//  Heimdall
//
//  Created by Edho Prasetyo on 17/09/25.
//

import Foundation

struct SharedDataStore {
    static let suiteName = "group.com.personal.heimdall"
    static let key = "latestMessage"

    static func saveMessage(_ message: String) {
        UserDefaults(suiteName: suiteName)?.set(message, forKey: key)
    }

    static func loadMessage() -> String {
        UserDefaults(suiteName: suiteName)?.string(forKey: key) ?? "No message yet"
    }
}
