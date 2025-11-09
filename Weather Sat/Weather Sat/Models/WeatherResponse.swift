//
//  WeatherResponse.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation
import SwiftData

@Model
final class WeatherResponse {
    // Main data object structure returned by Open Weather API
    var temp: Double
    var windSpeed: Double
    var windDirection: Int
    var weather: [WeatherObservation]
    var dailyWeather: [DailyWeatherForcast]
    var lon: Double
    var lat: Double
    var timezoneOffset: Int

    init(from dto: WeatherResponseDTO ) {
        self.temp = dto.temp
        self.windSpeed = dto.windSpeed
        self.windDirection = dto.windDirection
        self.weather = dto.weather.map(WeatherObservation.init)
        self.dailyWeather = dto.dailyWeather.map(DailyWeatherForcast.init)
        self.lon = dto.lon
        self.lat = dto.lat
        self.timezoneOffset = dto.timezoneOffset
    }

    init(temp: Double,
         windSpeed: Double,
         windDirection: Int,
         weather: [WeatherObservation],
         dailyWeather: [DailyWeatherForcast],
         lon: Double,
         lat: Double,
         timezoneOffset: Int) {
        self.temp = temp
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.weather = weather
        self.dailyWeather = dailyWeather
        self.lon = lon
        self.lat = lat
        self.timezoneOffset = timezoneOffset
    }

    // MARK: - Example
    static var example: WeatherResponse {
        return WeatherResponse(
            temp: 12.99,
            windSpeed: 5.5099999999999998,
            windDirection: 325,
            weather: [WeatherObservation(from: WeatherObservationDTO.example)],
            dailyWeather: [DailyWeatherForcast(from: DailyWeatherForcastDTO.example)],
            lon: 144.96000000000001,
            lat: -37.810000000000002,
            timezoneOffset: 36000
        )
    }
}
