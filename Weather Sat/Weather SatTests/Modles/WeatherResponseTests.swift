//
//  WeatherResponseTests.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 30/12/2025.
//

import Testing
@testable import Weather_Sat

struct WeatherResponseTests {

    @Test func initToFromDTORoundTrip() async throws {
        let weatherObservation = WeatherObservation(
            detail: TestingUtilities.randomString(length: 10),
            desc: TestingUtilities.randomString(length: 10),
            icon: TestingUtilities.randomString(length: 10)
        )

        let dailyWeatherForecast = DailyWeatherForcast (
            dt: Int.random(in: 1...100),
            sunrise: Int.random(in: 1...100),
            sunset: Int.random(in: 1...100),
            tempDay: Double.random(in: 1...100),
            tempMin: Double.random(in: 1...100),
            tempMax: Double.random(in: 1...100),
            tempNight: Double.random(in: 1...100),
            tempEve: Double.random(in: 1...100),
            tempMorn: Double.random(in: 1...100),
            weather: [WeatherObservation(detail: TestingUtilities.randomString(length: 10), desc: TestingUtilities.randomString(length: 10), icon: TestingUtilities.randomString(length: 10))],
            windSpeed: Double.random(in: 1...100),
            windDirection: Int.random(in: 1...100)
        )

        let weatherResponse = WeatherResponse(
            temp: Double.random(in: 1...100),
            windSpeed: Double.random(in: 1...100),
            windDirection: Int.random(in: 1...100),
            weather: [weatherObservation],
            dailyWeather: [dailyWeatherForecast],
            lon: Double.random(in: 1...100),
            lat: Double.random(in: 1...100),
            timezoneOffset: Int.random(in: 1...100)
        )

        let weatherResponseDTO = WeatherResponseDTO(from: weatherResponse)
        let weatherResponseFromDTO = WeatherResponse(from: weatherResponseDTO)

        #expect(weatherResponse.temp == weatherResponseFromDTO.temp)
        #expect(weatherResponse.windSpeed == weatherResponseFromDTO.windSpeed)
        #expect(weatherResponse.windDirection == weatherResponseFromDTO.windDirection)
        #expect(weatherResponse.weather.first?.detail == weatherResponseFromDTO.weather.first?.detail)
        #expect(weatherResponse.dailyWeather.first?.dt == weatherResponseFromDTO.dailyWeather.first?.dt)
        #expect(weatherResponse.lon == weatherResponseFromDTO.lon)
        #expect(weatherResponse.lat == weatherResponseFromDTO.lat)
        #expect(weatherResponse.timezoneOffset == weatherResponseFromDTO.timezoneOffset)
    }

}
