//
//  WeatherResponse.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation

nonisolated struct WeatherResponseDTO: Codable, Hashable, Equatable {
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

    init(from weatherResponse: WeatherResponse) {
        self.temp = weatherResponse.temp
        self.windSpeed = weatherResponse.windSpeed
        self.windDirection = weatherResponse.windDirection
        self.weather = weatherResponse.weather.compactMap { WeatherObservationDTO(from: $0) }
        self.dailyWeather = weatherResponse.dailyWeather.compactMap { .init(from: $0) }
        self.lon = weatherResponse.lon
        self.lat = weatherResponse.lat
        self.timezoneOffset = weatherResponse.timezoneOffset
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

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // current: { temp, windSpeed, windDirection, weather }
        var currentContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .current)
        try currentContainer.encode(temp, forKey: .temp)
        try currentContainer.encode(windSpeed, forKey: .windSpeed)
        try currentContainer.encode(windDirection, forKey: .windDirection)
        try currentContainer.encode(weather, forKey: .weather)

        // top-level keys
        try container.encode(dailyWeather, forKey: .daily)
        try container.encode(lon, forKey: .lon)
        try container.encode(lat, forKey: .lat)
        try container.encode(timezoneOffset, forKey: .timezoneOffset)
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

    // MARK: - Equatible
    static func == (lhs: WeatherResponseDTO, rhs: WeatherResponseDTO) -> Bool {
        return lhs.temp == rhs.temp
        && lhs.windSpeed == rhs.windSpeed
        && lhs.windDirection == rhs.windDirection
        && lhs.weather == rhs.weather
        && lhs.dailyWeather == rhs.dailyWeather
        && lhs.lon == rhs.lon
        && lhs.lat == rhs.lat
        && lhs.timezoneOffset == rhs.timezoneOffset
    }
}
