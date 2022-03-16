//
//  Double+extension.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 15.03.2022.
//

import Foundation

extension Double {
    
    func roundDouble() -> String {
        return String(format: "%.1f", self)
    }
}
