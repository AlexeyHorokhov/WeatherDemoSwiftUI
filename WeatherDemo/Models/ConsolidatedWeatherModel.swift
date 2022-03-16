//
//  ConsolidatedWeather.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 11.03.2022.
//

import Foundation

struct DetailedCityModel: Codable, Hashable {
    
    let cityId: Int
    let cityName, sunrise, sunset: String
    let consolidatedWeatherModels: [ConsolidatedWeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case cityId = "woeid"
        case cityName = "title"
        case sunrise = "sun_rise"
        case sunset = "sun_set"
        case consolidatedWeatherModels = "consolidated_weather"
    }
    
    // As we need only tomorrow’s weather forecast we are search for it.
    // Ofc we can avoid it right in Decode part using Decoder and Container in order to parse String to Date
    // but I desided to do it in this way
    func getTomorrowModel() -> ConsolidatedWeatherModel? {
        var dictionary: [TimeInterval?: ConsolidatedWeatherModel] = [:]
        consolidatedWeatherModels.forEach { model in
            let stringToDate = model.applicableDate.toDateWith(format: .short).noon?.timeIntervalSince1970
            dictionary[stringToDate] = model
        }
        
        guard let tomorrow = Date.tomorrow?.timeIntervalSince1970 else { return nil }
        return dictionary[tomorrow]
    }
    
    // Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cityId)
    }
    
    static func == (lhs: DetailedCityModel, rhs: DetailedCityModel) -> Bool {
        return lhs.cityId == rhs.cityId
    }
}

struct ConsolidatedWeatherModel: Codable, Identifiable {
    
    let id, humidity: Int
    let weatherStateName, weatherStateIcon, dateCreated, applicableDate: String
    let minTemperature, maxTemperature, currentTemperature, windSpeed, airPressure, visibility: Double
    
    enum CodingKeys: String, CodingKey {
        case id, humidity, visibility
        case weatherStateName = "weather_state_name"
        case weatherStateIcon = "weather_state_abbr"
        case dateCreated = "created"
        case applicableDate = "applicable_date"
        case minTemperature = "min_temp"
        case maxTemperature = "max_temp"
        case currentTemperature = "the_temp"
        case windSpeed = "wind_speed"
        case airPressure = "air_pressure"
    }
    
    func iconURL() -> URL? {
        return URL.urlForWeatherIconWith(iconId: weatherStateIcon)
    }
}
