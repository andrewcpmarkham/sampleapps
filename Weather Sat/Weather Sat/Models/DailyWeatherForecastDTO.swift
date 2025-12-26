//
//  DailyWeatherForecastDTO.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation

nonisolated struct DailyWeatherForcastDTO: Codable, Hashable, Identifiable {
    let id = UUID()

    // Sub data object structure returned by API
    // swiftlint:disable:next identifier_name
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let tempDay: Double
    let tempMin: Double
    let tempMax: Double
    let tempNight: Double
    let tempEve: Double
    let tempMorn: Double
    let weather: [WeatherObservationDTO]
    let windSpeed: Double
    let windDirection: Int

    enum CodingKeys: String, CodingKey {
        // swiftlint:disable:next identifier_name
        case dt
        case sunrise
        case sunset
        case temp
        case tempDay = "day"
        case tempMin = "min"
        case tempMax = "max"
        case tempNight = "night"
        case tempEve = "eve"
        case tempMorn = "morn"
        case weather
        case windSpeed = "wind_speed"
        case windDirection = "wind_deg"
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
    weather: [WeatherObservationDTO],
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

    init(from dailyWeatherForcast: DailyWeatherForcast) {
        self.dt = dailyWeatherForcast.dt
        self.sunrise = dailyWeatherForcast.sunrise
        self.sunset = dailyWeatherForcast.sunset
        self.tempDay = dailyWeatherForcast.tempDay
        self.tempMin = dailyWeatherForcast.tempMin
        self.tempMax = dailyWeatherForcast.tempMax
        self.tempNight = dailyWeatherForcast.tempNight
        self.tempEve = dailyWeatherForcast.tempEve
        self.tempMorn = dailyWeatherForcast.tempMorn
        self.weather = dailyWeatherForcast.weather.compactMap{.init(from: $0)}
        self.windSpeed = dailyWeatherForcast.windSpeed
        self.windDirection = dailyWeatherForcast.windDirection
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Picking the data wanted
        dt = try container.decode(Int.self, forKey: .dt)
        sunrise = try container.decode(Int.self, forKey: .sunrise)
        sunset = try container.decode(Int.self, forKey: .sunset)
        let tempContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .temp)
        tempDay = try tempContainer.decode(Double.self, forKey: .tempDay)
        tempMin = try tempContainer.decode(Double.self, forKey: .tempMin)
        tempMax = try tempContainer.decode(Double.self, forKey: .tempMax)
        tempNight = try tempContainer.decode(Double.self, forKey: .tempNight)
        tempEve = try tempContainer.decode(Double.self, forKey: .tempEve)
        tempMorn = try tempContainer.decode(Double.self, forKey: .tempMorn)
        weather = try container.decode([WeatherObservationDTO].self, forKey: .weather)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        windDirection = try container.decode(Int.self, forKey: .windDirection)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // top-level values
        try container.encode(dt, forKey: .dt)
        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(sunset, forKey: .sunset)

        // nested temp container
        var tempContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .temp)
        try tempContainer.encode(tempDay, forKey: .tempDay)
        try tempContainer.encode(tempMin, forKey: .tempMin)
        try tempContainer.encode(tempMax, forKey: .tempMax)
        try tempContainer.encode(tempNight, forKey: .tempNight)
        try tempContainer.encode(tempEve, forKey: .tempEve)
        try tempContainer.encode(tempMorn, forKey: .tempMorn)

        // remaining top-level values
        try container.encode(weather, forKey: .weather)
        try container.encode(windSpeed, forKey: .windSpeed)
        try container.encode(windDirection, forKey: .windDirection)
    }

    // MARK: - Example
    static var example: DailyWeatherForcastDTO {
        return DailyWeatherForcastDTO(
            dt: 1758333600,
            sunrise: 1758312795,
            sunset: 1758356059,
            tempDay: 13.890000000000001,
            tempMin: 7.7300000000000004,
            tempMax: 14.119999999999999,
            tempNight: 12.06,
            tempEve: 13.789999999999999,
            tempMorn: 8.0999999999999996,
            weather: [WeatherObservationDTO.example],
            windSpeed: 7.3499999999999996,
            windDirection: 258
        )
    }
}
