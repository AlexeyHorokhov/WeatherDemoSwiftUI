//
//  WeatherService.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 12.03.2022.
//

import Foundation
import Combine
import SwiftUI

enum APIError: Error, LocalizedError {
    case unknown, apiError(reason: String), parserError(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason), .parserError(let reason):
            return reason
        }
    }
}

/// Main service to load, chain and zip data in one Publisher. Used with generics to decode data. Primitive Error handling included.
struct WeatherService {
    
    func fetchNeededCities() -> AnyPublisher<[DetailedCityModel], APIError> {
        return Publishers.Sequence(sequence: NeededCities.allCases)
            .flatMap { city in
                fetch(city: city)
            }
            .collect()
            .map { cities -> AnyPublisher<[DetailedCityModel], APIError> in
                Publishers.Sequence(sequence: cities)
                    .flatMap { detailedCity in
                        fetchWeather(forCityId: detailedCity.cityId)
                    }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    func fetch(city: NeededCities) -> AnyPublisher<CityModel, APIError> {
        guard let url = URL.urlFor(city: city) else { return Empty().eraseToAnyPublisher() }
        
        let publisher: AnyPublisher<[CityModel], APIError> = fetch(url: url)
        return publisher
            .compactMap { $0.first }
            .eraseToAnyPublisher()
    }
    
    func fetchWeather(forCityId id: Int) -> AnyPublisher<DetailedCityModel, APIError> {
        guard let url = URL.urlForWeatherWith(cityId: id) else { return Empty().eraseToAnyPublisher() }
        
        return fetch(url: url)
    }
    
    private func fetch(url: URL) -> AnyPublisher<Data, APIError> {
        let request = URLRequest(url: url)
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                return data
            }
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func fetch<T: Decodable>(url: URL) -> AnyPublisher<T, APIError> {
        fetch(url: url)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? DecodingError {
                    var errorToReport = error.localizedDescription
                    switch error {
                    case .dataCorrupted(let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath
                            .map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) - (\(details))"
                    case .keyNotFound(let key, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath
                            .map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                    case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath
                            .map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                    @unknown default:
                        break
                    }
                    return APIError.parserError(reason: errorToReport)
                } else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
}
