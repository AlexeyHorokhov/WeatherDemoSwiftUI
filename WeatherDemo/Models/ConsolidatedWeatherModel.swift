//
//  ConsolidatedWeather.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 11.03.2022.
//

import Foundation

/// This model is our main source of data in app. We can get json for this model via https://www.metaweather.com/api/location/CityID. It roughly will look like this.
/// {
/// "consolidated_weather": [
///    {
///        "id": 6209956119314432,
///        "weather_state_name": "Heavy Rain",
///        "weather_state_abbr": "hr",
///        "wind_direction_compass": "ESE",
///        "created": "2022-03-16T12:59:02.379954Z",
///        "applicable_date": "2022-03-16",
///        "min_temp": 7.29,
///        "max_temp": 13.205,
///        "the_temp": 10.925,
///        "wind_speed": 4.95896139729049,
///        "wind_direction": 105.57223838301438,
///        "air_pressure": 1017.5,
///        "humidity": 87,
///        "visibility": 6.357559353376282,
///        "predictability": 77
///    },
///    ...
/// ],
/// "time": "2022-03-16T13:20:34.041552Z",
/// "sun_rise": "2022-03-16T06:12:34.433822Z",
/// "sun_set": "2022-03-16T18:06:41.703136Z",
/// "timezone_name": "LMT",
/// "title": "London",
/// "location_type": "City",
/// "woeid": 44418,
/// "latt_long": "51.506321,-0.12714",
/// "timezone": "Europe/London"
/// }
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

/// This model is part of our main model DetailedCityModel. It mostly contains detailed waether information for sprecific day
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
    
    // This func returns completed URL for weather icon
    func iconURL() -> URL? {
        return URL.urlForWeatherIconWith(iconId: weatherStateIcon)
    }
}
