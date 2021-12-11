//
//  LocationUnitTests.swift
//  Weather AppTests
//
//  Created by Andrew CP Markham on 11/6/21.
//

import XCTest
@testable import Weather_App

class LocationUnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocationsClass() throws {
        let location = Location(id: 2147714, city: "Sydney", country: "Australia", lat: -33.87, lon: 151.21)
        
        XCTAssertTrue("\(type(of: location))" == "Location")
    }
}
