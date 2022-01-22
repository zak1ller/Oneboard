//
//  Date+Extension.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation

extension Date {
    static func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    static func stringToDate(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: string)!
    }
    
    static func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM EEEE HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

