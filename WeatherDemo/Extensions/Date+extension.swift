//
//  Date+extension.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 15.03.2022.
//

import Foundation

/// This extension need for getting tomorrow day only.
extension Date {
    
    static var tomorrow: Date? { return Date().dayAfter }
    
    var dayAfter: Date? {
        guard let noon = noon else { return nil }
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)
    }
    var noon: Date? {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)
    }
}
