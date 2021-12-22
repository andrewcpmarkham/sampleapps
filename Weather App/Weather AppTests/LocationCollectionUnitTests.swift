//
//  LocationCollectionUnitTests.swift
//  Weather AppTests
//
//  Created by Andrew CP Markham on 11/6/21.
//

import XCTest
@testable import Weather_App

class LocationCollectionUnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConnections() throws {
        XCTAssertTrue(LocationCollection.shared.getLocationsCount() == 3,
            // swiftlint:disable:next line_length
            "There aren't 20 locations proivded in the locations collection - Only \(LocationCollection.shared.getLocationsCount()) provided.")
    }

    func testCollectionIsCorrectToAPI() throws {

    // Not an ideal test as it only tests one object randomely but hey its a start
        let getWeatherFromAPIDelegate = GetWeatherFromAPIDelegate()

        let location = LocationCollection.shared.getLocationAtIndex(
            index: Int.random(in: 0..<LocationCollection.shared.getLocationsCount())
        )

        guard
            let idUnwrapped = location?.id,
            let cityUnwrapped = location?.city,
            let lonUnwrapped = location?.lon,
            let latUnwrapped = location?.lat

        else {
            XCTFail("Values for lat, lon are required values for testCollectionIsCorrectToAPI test")
            return
        }

        getWeatherFromAPIDelegate.weatherRequest(
            cityLon: lonUnwrapped,
            cityLat: latUnwrapped,
            optionalRequest: false, completion: { (weather, error) in
            if let error = error {
                XCTFail("The following error occured from the request to the API: \(error)")
            }

            guard let weather = weather else {
                XCTFail("A weather respose was not attained for \(idUnwrapped) : \(cityUnwrapped)")
                return
            }

            XCTAssertTrue(
                lonUnwrapped == weather.lon,
                // swiftlint:disable:next line_length
                "The \(cityUnwrapped) longitude of \(lonUnwrapped) wasn't  the same as returned from the API \(weather.lon)"
            )
            XCTAssertTrue(
                latUnwrapped == weather.lat,
                // swiftlint:disable:next line_length
                "The \(cityUnwrapped) latitude of \(latUnwrapped) wasn't  the same as returned from the API \(weather.lat)"
            )
        })
    }
}
