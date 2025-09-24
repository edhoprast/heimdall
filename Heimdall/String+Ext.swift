//
//  Helper.swift
//  Heimdall
//
//  Created by ByteDance on 9/24/25.
//

import Foundation

extension String {
    public func stringToDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Jakarta") // Indonesia WIB
        return formatter.date(from: self)
    }
}
