//
//  LocationTests.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 30/12/2025.
//

import Foundation
import Testing
@testable import Weather_Sat


struct LocationTests {

    enum TypeError: Error, LocalizedError {
        case conversionFailed

        var errorDescription: String {
            switch self {
            case .conversionFailed:
                return "Location object creation failed for DTO when it should have succeeded!"
            }
        }
    }

    @Test func initToFromDTORoundTrip() async throws {
        let location = Location(
            id: Int.random(in: 0...100),
            city: TestingUtilities.randomString(length: 10),
            state: TestingUtilities.randomString(length: 10),
            country: TestingUtilities.randomString(length: 10),
            lat: Double.random(in: 0...100),
            lon: Double.random(in: 0...100)
        )

        let locationDTO = LocationDTO(from: location)
        guard let locationFromDTO = Location(from: locationDTO) else {
            throw TypeError.conversionFailed
        }
        #expect(location.id == locationFromDTO.id)
        #expect(location.city == locationFromDTO.city)
        #expect(location.state == locationFromDTO.state)
        #expect(location.country == locationFromDTO.country)
        #expect(location.lat == locationFromDTO.lat)
        #expect(location.lon == locationFromDTO.lon)
    }

    @Test func getDataDateTests() async throws {
        let location = Location.example
        let calendar = Calendar.current

        // Test for no data
        location.weather = nil
        let noDataDate = location.getDataDate()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date.now)!
        #expect( noDataDate <= yesterday)

        //Test for data before today
        let daylyWeather = DailyWeatherForcast(
            dt: Date.utcIntFromDate(Date.distantPast),
            sunrise: Int.random(in: 1...100),
            sunset: Int.random(in: 1...100),
            tempDay: Double.random(in: 1...100),
            tempMin: Double.random(in: 1...100),
            tempMax: Double.random(in: 1...100),
            tempNight: Double.random(in: 1...100),
            tempEve: Double.random(in: 1...100),
            tempMorn: Double.random(in: 1...100),
            weather: [WeatherObservation.example],
            windSpeed: Double.random(in: 1...100),
            windDirection: Int.random(in: 1...100)
        )
        let weatherResponse: WeatherResponse = .init(
            temp: Double.random(in: 1...100),
            windSpeed: Double.random(in: 1...100),
            windDirection: Int.random(in: 1...100),
            weather: [],
            dailyWeather: [daylyWeather],
            lon: Double.random(in: 1...100),
            lat: Double.random(in: 1...100),
            timezoneOffset: 0
        )
        location.weather = weatherResponse
        let oldDataDate = location.getDataDate()
        #expect( oldDataDate <= yesterday)

        //Test for data today
        daylyWeather.dt = Date.utcIntFromDate(Date.now)
        location.weather?.dailyWeather[0] = daylyWeather
        let todaysDataDate = location.getDataDate()
        #expect( todaysDataDate > Date(timeIntervalSinceNow: -120)) // 2 mins ago

        // TODO: - Test timeZone Offsets

    }
}
