//
//  CityModel.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 11.03.2022.
//

import Foundation

enum NeededCities: String, CaseIterable {
    
    case gothenburg
    case stockholm
    case mountainView = "Mountain%20View"
    case london
    case newYork = "New%20York"
    case berlin
}

/// We need this model in order to get city ID.
/// We can get it using API call https://www.metaweather.com/api/location/search/?query=ourCity
///
/// Example:
/// API call https://www.metaweather.com/api/location/search/?query=London will return us JSON which we will parse using this Model
///  {
///     "title": "London",
///     "location_type": "City",
///     "woeid": 44418,
///     "latt_long": "51.506321,-0.12714"
///  }
/// For my purpose I don't really need "latt_long" and "location_type" fields so i'll ignore them.
struct CityModel: Codable {
    
    let cityName: String
    let cityId: Int
    
    enum CodingKeys: String, CodingKey {
        case cityName = "title"
        case cityId = "woeid"
    }
}
