//
//  CityDTO.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation
import Testing
@testable import Weather_Sat

struct CityDTOTests {

    @Test func testDecodeCityDTO_fixture() throws {
        let cities: [CityDTO] = try UnitTestUtilities.loadFixture("city.mock.data") { decoder in
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            // decoder.dateDecodingStrategy = .iso8601
        }

        #expect(cities.count == 12)

        if let first = cities.first {
            #expect(first.id == 1)
            #expect(first.name == "Sydney")
            #expect(first.state == "NSW")
            #expect(first.country == "AU")

            let coord = try #require(
                first.coord,
                "Failed to load coord DTO object from fixture data"
            )
            #expect(coord.lat == -122.406417)
            #expect(coord.lon == 37.785834)
        }
    }

    @MainActor
    @Test func testDecodeCityDTO_MissingData() async throws {

        let missingCityData = """
            [
                {
                    "name": "Sydney",
                    "state": "NSW",
                    "country": "AU",
                    "coord": {
                        "lon": 37.785834,
                        "lat": -122.406417
                    }
                },
                {
                    "id": 2,
                    "name": "Melbourne",
                    "state": "VIC",
                    "country": "AU"
                }
            ]
        """

        let cities: [CityDTO] = try UnitTestUtilities.loadData(missingCityData) { decoder in }
        #expect(cities.count == 2)

        let firstCity = try #require(
            cities.first,
            "Failed to load first city from  data"
        )
        #expect(firstCity.id == nil)
        #expect(firstCity.name == "Sydney")

        let lastCity = try #require(
            cities.last,
            "Failed to load last city from  data"
        )
        #expect(lastCity.id == 2)
        #expect(lastCity.coord == nil)
    }

    @MainActor
    @Test func testDecodeCityDTO_WronglyTypedData() async throws {
        let wrongTypedCityData = """
            [
                {
                    "id": 1,
                    "name": "Sydney",
                    "state": "NSW",
                    "country": "AU",
                    "coord": {
                        "lon": "37.785834",
                        "lat": -122.406417
                    }
                },
                {
                    "id": "2",
                    "name": "Sydney",
                    "state": "NSW",
                    "country": "AU",
                    "coord": {
                        "lon": 37.785834,
                        "lat": -122.406417
                    }
                }
            ]
        """
        let cities: [CityDTO] = try UnitTestUtilities.loadData(wrongTypedCityData) { decoder in }
        #expect(cities.count == 2)

        let firstCity = try #require(
            cities.first,
            "Failed to load first city from  data"
        )
        let firstCityCoord = try #require(
            firstCity.coord,
            "Failed to load first city coord from  data"
        )
        #expect(firstCityCoord.lon == nil)
        #expect(firstCityCoord.lat == -122.406417)

        let lastCity = try #require(
            cities.last,
            "Failed to load last city from  data"
        )
        #expect(lastCity.id == nil)
    }

}
