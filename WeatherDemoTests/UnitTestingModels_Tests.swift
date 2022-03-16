//
//  UnitTestingModels_Tests.swift
//  WeatherDemoTests
//
//  Created by Oleksii Horokhov on 16.03.2022.
//

import XCTest
@testable import WeatherDemo

class UnitTestingModelsTests: XCTestCase {
    
    // Naming structure: test_
    
    // Testing structure: Given, When, Then

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_NeededCitiesEnum_Count_shouldBeSix() {
        // Given
        let count = NeededCities.allCases.count
        
        // When
        
        
        // Then
        XCTAssertEqual(count, 6)
        XCTAssertTrue(count == 6)
    }
    

}
