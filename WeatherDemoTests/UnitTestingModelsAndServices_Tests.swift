//
//  UnitTestingModelsAndServices_Tests.swift
//  WeatherDemoTests
//
//  Created by Oleksii Horokhov on 16.03.2022.
//

import XCTest
@testable import WeatherDemo
import Combine

class UnitTestingModelsAndServicesTests: XCTestCase {
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_NeededCitiesEnum_Count_shouldBeSix() {
        let count = NeededCities.allCases.count
        
        XCTAssertEqual(count, 6)
        XCTAssertTrue(count == 6)
    }
    
    func test_WeatherService_WeatherData_DetailedCityModelshouldBeNotEmpty() {
        let service = WeatherService()
        let expectation = XCTestExpectation(description: #function)
        var cityModels: [DetailedCityModel] = []
        
        service.fetchNeededCities()
            .receive(on: RunLoop.main)
            .replaceError(with: [])
            .sink(receiveValue: { detailedCities in
                cityModels = detailedCities
                expectation.fulfill()
            })
            .store(in: &cancellableSet)
        
        wait(for: [expectation], timeout: 3)
        
        XCTAssert(!cityModels.isEmpty, "cityModels list is empty")
    }
    
    func test_WeatherService_CityModel_shouldExist() {
        let service = WeatherService()
        let expectation = XCTestExpectation(description: #function)
        var cityModel: CityModel?
        
        service.fetch(city: .london)
            .receive(on: RunLoop.main)
            .replaceError(with: CityModel(cityName: "London", cityId: 1))
            .sink(receiveValue: { city in
                cityModel = city
                expectation.fulfill()
            })
            .store(in: &cancellableSet)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssert(cityModel != nil, "City model is exist")
        XCTAssertTrue(cityModel?.cityName == "London")
    }
    
    func test_WeatherService_WeatherData_shouldBeNotEmpty() {
        let service = WeatherService()
        let cityId = 44418 // London ID
        let expectation = XCTestExpectation(description: #function)
        var detailedCityModel: DetailedCityModel?
        
        service.fetchWeather(forCityId: cityId)
            .receive(on: RunLoop.main)
            .replaceError(with: previewWeather)
            .sink(receiveValue: { city in
                detailedCityModel = city
                expectation.fulfill()
            })
            .store(in: &cancellableSet)
        
        wait(for: [expectation], timeout: 3)
        
        XCTAssert(detailedCityModel != nil, "City model is exist")
        XCTAssertTrue(detailedCityModel?.cityName == "London")
        XCTAssertFalse(detailedCityModel?.cityName == "Berlin")
        XCTAssertFalse(detailedCityModel?.consolidatedWeatherModels.count ?? 0 < 1)
    }
}
