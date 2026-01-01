//
//  DailyWeatherForcastTests.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 29/12/2025.
//

import Testing
@testable import Weather_Sat

struct DailyWeatherForcastTests {

    @Test func initToFromDTORoundTrip() async throws {
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
        let dailyWeatherForecastDTO = DailyWeatherForcastDTO(from: dailyWeatherForecast)
        let dailyWeatherForecastFromDTO = DailyWeatherForcast(from: dailyWeatherForecastDTO)
        
        #expect(dailyWeatherForecast.sunrise == dailyWeatherForecastFromDTO.sunrise)
        #expect(dailyWeatherForecast.sunset == dailyWeatherForecastFromDTO.sunset)
        #expect(dailyWeatherForecast.tempDay == dailyWeatherForecastFromDTO.tempDay)
        #expect(dailyWeatherForecast.tempMin == dailyWeatherForecastFromDTO.tempMin)
        #expect(dailyWeatherForecast.tempMax == dailyWeatherForecastFromDTO.tempMax)
        #expect(dailyWeatherForecast.tempNight == dailyWeatherForecastFromDTO.tempNight)
        #expect(dailyWeatherForecast.tempEve == dailyWeatherForecastFromDTO.tempEve)
        #expect(dailyWeatherForecast.tempMorn == dailyWeatherForecastFromDTO.tempMorn)
        #expect(dailyWeatherForecast.weather.first?.detail == dailyWeatherForecastFromDTO.weather.first?.detail)
        #expect(dailyWeatherForecast.weather.first?.desc == dailyWeatherForecastFromDTO.weather.first?.desc)
        #expect(dailyWeatherForecast.weather.first?.icon == dailyWeatherForecastFromDTO.weather.first?.icon)
        #expect(dailyWeatherForecast.windSpeed == dailyWeatherForecastFromDTO.windSpeed)
        #expect(dailyWeatherForecast.windDirection == dailyWeatherForecastFromDTO.windDirection)
    }
}
