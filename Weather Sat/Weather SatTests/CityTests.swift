//
//  CityTests.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 2/11/2025.
//

import SwiftData
import Testing
@testable import Weather_Sat

struct CityTests {

    // MARK: - Setup
    func makeContainer() throws -> ModelContainer {
            let schema = Schema([
                City.self,
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            return try ModelContainer(for: schema, configurations: config)
        }

    // Test Creation of City from DTO
    @MainActor
    @Test func initFromDTO() async throws {
        let cities: [CityDTO] = try UnitTestUtilities.loadFixture("city.mock.data") { decoder in }

        let firstCityDTO = try #require(
            cities.first,
            "Failed to load first city from fixture data"
        )

        let container = try makeContainer()
        let context = container.mainContext

        #expect(throws: Never.self) {
            let firstCity = try City(from: firstCityDTO)

            context.insert(firstCity)
            try context.save()

            let fetched = try context.fetch(FetchDescriptor<City>())
            #expect(fetched.count == 1, "Expected exactly one City persisted")

            let savedCity = try #require(fetched.first, "No City returned from fetch")
            #expect(savedCity.id == 1)
            #expect(savedCity.name == "Sydney")
            #expect(savedCity.state == "NSW")
            #expect(savedCity.country == "AU")

            let coord = try #require(
                savedCity.coord,
                "Failed to load coord DTO object from fixture data"
            )
            #expect(coord.lat == -122.406417)
            #expect(coord.lon == 37.785834)
        }
    }

    // Test for wronly typed data
    @MainActor
    @Test func initFromDTO_MissingData() async throws {
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

        #expect(throws: DecodingError.self) {
            _ = try City(from: firstCity)
        }

        let lastCity = try #require(
            cities.last,
            "Failed to load last city from  data"
        )
        #expect(throws: DecodingError.self) {
            _ = try City(from: lastCity)
        }
    }

    // Test for missing data
    @MainActor
    @Test func initFromDTO_WronglyTypedData() async throws {
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

        #expect(throws: DecodingError.self) {
            _ = try City(from: firstCity)
        }

        let lastCity = try #require(
            cities.last,
            "Failed to load last city from  data"
        )
        #expect(throws: DecodingError.self) {
            _ = try City(from: lastCity)
        }
    }
}
