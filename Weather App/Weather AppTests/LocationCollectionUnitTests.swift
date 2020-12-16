//
//  LocationCollectionUnitTests.swift
//  Weather AppTests
//
//  Created by Andrew CP Markham on 20/9/20.
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
        XCTAssertTrue(LocationCollection.shared.getLocationsCount() >= 20, "There aren't 20 locations proivded in the locations collection - Only \(LocationCollection.shared.getLocationsCount()) provided.")
    }
    
    func testCollectionIsCorrectToAPI() throws {
        
    //Not an ideal test as it only tests one object randomely but hey its a start
        let getWeatherFromAPIDelegate = GetWeatherFromAPIDelegate()
        
        let location = LocationCollection.shared.getLocationAtIndex(index: Int.random(in: 0..<LocationCollection.shared.getLocationsCount()))
        
        getWeatherFromAPIDelegate.weatherRequest(cityLon: location.lon!, cityLat: location.lat!, optionalRequest: false, completion: {
            (weather, error) in
            if let error = error{
                XCTFail("The following error occured from the request to the API: \(error)")
            }
                
            guard let weather = weather else {
                XCTFail("A weather respose was not attained for \(location.id!) : \(location.city!)")
                return
            }
                
            XCTAssertTrue(location.lon == weather.lon, "The \(location.city!) longitude of \(location.lon!) wasn't  the same as returned from the API \(weather.lon)")
            XCTAssertTrue(location.lat == weather.lat, "The \(location.city!) latitude of \(location.lat!) wasn't  the same as returned from the API \(weather.lat)")
        })
    }
}
