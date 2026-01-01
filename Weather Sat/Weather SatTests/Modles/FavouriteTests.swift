//
//  FavouriteTests.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 30/12/2025.
//

import Foundation
import Testing
@testable import Weather_Sat

struct FavouriteTests {
    enum TypeError: Error, LocalizedError {
        case noWeatherData
        case currentFavouriteInstatiationFailed
        case dayFavouriteInstatiationFailed

        var errorDescription: String {
            switch self {
            case .noWeatherData:
                return "No weather data available."
            case .currentFavouriteInstatiationFailed:
                return "Current favourite failed to instatiate correctly."
            case .dayFavouriteInstatiationFailed:
                return "Day favourite failed to instatiate correctly."
            }
        }
    }

    @MainActor
    @Test func getFavourite() async throws {
        let location = Location.example
        guard
            let weatherResponse = location.weather,
            let weatherObservation = weatherResponse.weather.first,
            let weeklyWeather = location.weather?.dailyWeather,
            let dailyWeather = weeklyWeather.first
        else {
            throw TypeError.noWeatherData
        }


        let testCurrentFavourite = Favourite.getFavourite(for: location, forecast: .current)
        guard case let .current(currentLocation, currentWeatherResponse, currentWeatherObservation) = testCurrentFavourite else {
            throw TypeError.currentFavouriteInstatiationFailed
        }
        #expect(LocationDTO(from: location) == currentLocation)
        #expect(WeatherResponseDTO(from: weatherResponse) == currentWeatherResponse)
        #expect(WeatherObservationDTO(from: weatherObservation) == currentWeatherObservation)


        let testDailyFavourite = Favourite.getFavourite(for: location, forecast: .day)
        guard case let .day(dayLocation, dayWeatherResponse, dayWeatherForcast) = testDailyFavourite else {
            throw TypeError.dayFavouriteInstatiationFailed
        }
        #expect(LocationDTO(from: location) == dayLocation)
        #expect(WeatherResponseDTO(from: weatherResponse) == dayWeatherResponse)
        #expect(DailyWeatherForcastDTO(from: dailyWeather) == dayWeatherForcast)

        let testWeeklyFavourite = Favourite.getFavourite(for: location, forecast: .week)
        guard case let .week(weekLocation, weekWeatherResponse, weekWeatherForcast) = testWeeklyFavourite else {
            throw TypeError.dayFavouriteInstatiationFailed
        }
        #expect(LocationDTO(from: location) == weekLocation)
        #expect(WeatherResponseDTO(from: weatherResponse) == weekWeatherResponse)
        let weeklyWeatherDTOs = weeklyWeather.map{DailyWeatherForcastDTO(from: $0)}
        #expect(weeklyWeatherDTOs == weekWeatherForcast)
    }

    @MainActor
    @Test func isFavourite() async throws {
        let testLocation = Location.example
        AppSettingsManager.shared.clear(.isFavourite)

        // Ensure first test starts clear
        #expect(!Favourite.isFavourite(location: testLocation, forecast: .current))
        let testCurrentFavourite = Favourite.getFavourite(for: testLocation, forecast: .current)

        // Test all types
        AppSettingsManager.shared.encode(testCurrentFavourite, for: .isFavourite)
        #expect(Favourite.isFavourite(location: testLocation, forecast: .current))

        let testDailyFavourite = Favourite.getFavourite(for: testLocation, forecast: .day)
        AppSettingsManager.shared.encode(testDailyFavourite, for: .isFavourite)
        #expect(Favourite.isFavourite(location: testLocation, forecast: .day))

        let testWeeklyFavourite = Favourite.getFavourite(for: testLocation, forecast: .week)
        AppSettingsManager.shared.encode(testWeeklyFavourite, for: .isFavourite)
        #expect(Favourite.isFavourite(location: testLocation, forecast: .week))

        // Test favourite is only set for last
        #expect(!Favourite.isFavourite(location: testLocation, forecast: .current))
        #expect(!Favourite.isFavourite(location: testLocation, forecast: .day))
    }
}
