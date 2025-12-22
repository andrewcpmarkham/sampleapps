//
//  WeatherResponse.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation

nonisolated struct WeatherResponseDTO: Decodable {
    // Main data object structure returned by Open Weather API
    let temp: Double
    let windSpeed: Double
    let windDirection: Int
    let weather: [WeatherObservationDTO]
    let dailyWeather: [DailyWeatherForcastDTO]
    let lon: Double
    let lat: Double
    let timezoneOffset: Int

    enum CodingKeys: String, CodingKey {
        case current
        case temp
        case windSpeed = "wind_speed"
        case windDirection = "wind_deg"
        case lon
        case lat
        case weather
        case daily
        case timezoneOffset = "timezone_offset"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Now pick the pieces you want
        let currentContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .current)
        temp = try currentContainer.decode(Double.self, forKey: .temp)
        windSpeed = try currentContainer.decode(Double.self, forKey: .windSpeed)
        windDirection = try currentContainer.decode(Int.self, forKey: .windDirection)
        weather = try currentContainer.decode([WeatherObservationDTO].self, forKey: .weather)
        dailyWeather = try container.decode([DailyWeatherForcastDTO].self, forKey: .daily)
        lon = try container.decode(Double.self, forKey: .lon)
        lat = try container.decode(Double.self, forKey: .lat)
        timezoneOffset = try container.decode(Int.self, forKey: .timezoneOffset)
    }

    init(temp: Double,
         windSpeed: Double,
         windDirection: Int,
         weather: [WeatherObservationDTO],
         dailyWeather: [DailyWeatherForcastDTO],
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
    static var example: WeatherResponseDTO {
        return WeatherResponseDTO(
            temp: 12.99,
            windSpeed: 5.5099999999999998,
            windDirection: 325,
            weather: [WeatherObservationDTO.example],
            dailyWeather: [DailyWeatherForcastDTO.example],
            lon: 144.96000000000001,
            lat: -37.810000000000002,
            timezoneOffset: 36000
        )
    }
}
