//
//  Date+Ext.swift
//  Heimdall
//
//  Created by ByteDance on 9/24/25.
//

import Foundation

extension Date {
    public func daysUntil() -> Int {
        let calendar = Calendar.current
        
        // Force calendar to use Indonesia timezone
        var indonesianCalendar = calendar
        indonesianCalendar.timeZone = TimeZone(identifier: "Asia/Jakarta")!
        
        let today = indonesianCalendar.startOfDay(for: Date())
        let target = indonesianCalendar.startOfDay(for: self)
        
        let components = indonesianCalendar.dateComponents([.day], from: today, to: target)
        return components.day ?? 0
    }
    
    func formatDate(format: String = "dd MMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX") // stable month names
        formatter.timeZone = TimeZone(identifier: "Asia/Jakarta") // WIB
        return formatter.string(from: self)
    }
}
