//
//  URL+extension.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 12.03.2022.
//

import Foundation

/// This extension was written to handle url construction. Can be rewriten to URLRequests.
extension URL {
    
    enum NeededURLs: String {
        case rootUrlString = "https://www.metaweather.com/api/"
        case cityURLSuffix = "location/search/?query={CITY_NAME}"
        case weatherURLSuffix = "/location/{CITY_ID}"
        case weatherIconURL = "https://www.metaweather.com//static/img/weather/png/64/{WEATHER_STATE}.png"
    }
    
    static func urlFor(city: NeededCities) -> URL? {
        let cityUrlWithReplacedSuffix = NeededURLs.cityURLSuffix.rawValue.replacingOccurrences(of: "{CITY_NAME}", with: city.rawValue)
        let completedCityURLString = NeededURLs.rootUrlString.rawValue + cityUrlWithReplacedSuffix
        guard let url = URL(string: completedCityURLString) else { return nil }
        
        return url
    }
    
    static func urlForWeatherWith(cityId: Int) -> URL? {
        let weatherUrlWithReplacedSuffix = NeededURLs.weatherURLSuffix.rawValue.replacingOccurrences(of: "{CITY_ID}", with: String(cityId))
        let completedWeatherURLString = NeededURLs.rootUrlString.rawValue + weatherUrlWithReplacedSuffix
        guard let weatherUrl = URL(string: completedWeatherURLString) else { return nil }
        
        return weatherUrl
    }
    
    static func urlForWeatherIconWith(iconId: String) -> URL? {
        let completedIconUrl = NeededURLs.weatherIconURL.rawValue.replacingOccurrences(of: "{WEATHER_STATE}", with: iconId)
        guard let weatherIconUrl = URL(string: completedIconUrl) else { return nil}
        
        return weatherIconUrl
    }
}
