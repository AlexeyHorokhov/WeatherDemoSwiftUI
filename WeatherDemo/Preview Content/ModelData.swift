//
//  ModelData.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 14.03.2022.
//

import Foundation

var previewWeather: DetailedCityModel = load("DummyWeatherData.json")

/// This global func need to convert mocked json into our weather model
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
