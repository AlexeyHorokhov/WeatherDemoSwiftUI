//
//  WeatherDemoApp.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 11.03.2022.
//

import SwiftUI

@main
struct WeatherDemoApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let weatherModel = WeatherViewModel(weatherService: weatherService)
            ContentView(weatherViewModel: weatherModel)
        }
    }
}
