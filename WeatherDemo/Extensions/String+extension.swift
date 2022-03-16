//
//  String+extension.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 14.03.2022.
//

import Foundation

enum DateFormatters: String {
    case short = "yyyy-MM-dd"
    case long = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    
}

extension String {
    
    func toDateWith(format: DateFormatters) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format.rawValue
        let date = dateFormatter.date(from: self)
        
        return date ?? Date()
    }
}
