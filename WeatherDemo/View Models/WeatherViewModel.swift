//
//  WeatherViewModel.swift
//  WeatherDemo
//
//  Created by Oleksii Horokhov on 11.03.2022.
//

import Foundation
import Combine

/// Main view model of application. Contains refresh method. Can be used for "pull to refresh" feature.
/// Also method include custom Error handling
final class WeatherViewModel: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var weatherModels: [DetailedCityModel] = []
    @Published var lastErrorReason: String?
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    // Self explanatory method to get DetailedCityModel with weather details. Also include alphabetic sorting.
    public func refresh() {
        weatherService.fetchNeededCities()
            .receive(on: RunLoop.main)
            .handleEvents(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(APIError.apiError(let reason)), .failure(APIError.parserError((let reason))):
                    self?.lastErrorReason = reason
                case .failure(APIError.unknown):
                    self?.lastErrorReason = "Unknown"
                default:
                    self?.lastErrorReason = nil
                }
            })
            .replaceError(with: [])
            .sink(receiveValue: { [weak self] detailedCities in
                self?.weatherModels = detailedCities.sorted { $0.cityName < $1.cityName}
            })
            .store(in: &cancellableSet)
    }
}
