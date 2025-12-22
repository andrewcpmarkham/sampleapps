//
//  DailyWeatherForcast.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation
import SwiftData

@Model
final class DailyWeatherForcast {
    private(set) var id = UUID()

    // Sub data object structure returned by API
    // swiftlint:disable:next identifier_name
    var dt: Int
    var sunrise: Int
    var sunset: Int
    var tempDay: Double
    var tempMin: Double
    var tempMax: Double
    var tempNight: Double
    var tempEve: Double
    var tempMorn: Double
    var weather: [WeatherObservation]
    var windSpeed: Double
    var windDirection: Int

    init (from dto: DailyWeatherForcastDTO) {
        self.dt = dto.dt
        self.sunrise = dto.sunrise
        self.sunset = dto.sunset
        self.tempDay = dto.tempDay
        self.tempMin = dto.tempMin
        self.tempMax = dto.tempMax
        self.tempNight = dto.tempNight
        self.tempEve = dto.tempEve
        self.tempMorn = dto.tempMorn
        self.weather = dto.weather.map(WeatherObservation.init)
        self.windSpeed = dto.windSpeed
        self.windDirection = dto.windDirection
    }

    init (
    dt: Int,
    sunrise: Int,
    sunset: Int,
    tempDay: Double,
    tempMin: Double,
    tempMax: Double,
    tempNight: Double,
    tempEve: Double,
    tempMorn: Double,
    weather: [WeatherObservation],
    windSpeed: Double,
    windDirection: Int) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.tempDay = tempDay
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.tempNight = tempNight
        self.tempEve = tempEve
        self.tempMorn = tempMorn
        self.weather = weather
        self.windSpeed = windSpeed
        self.windDirection = windDirection
    }


}

@MainActor
extension DailyWeatherForcast {
    // MARK: - Example
    static var example: DailyWeatherForcast {
        return DailyWeatherForcast(
            dt: 1758333600,
            sunrise: 1758312795,
            sunset: 1758356059,
            tempDay: 13.890000000000001,
            tempMin: 7.7300000000000004,
            tempMax: 14.119999999999999,
            tempNight: 12.06,
            tempEve: 13.789999999999999,
            tempMorn: 8.0999999999999996,
            weather: [WeatherObservation(from: WeatherObservationDTO.example)],
            windSpeed: 7.3499999999999996,
            windDirection: 258
        )
    }
}
