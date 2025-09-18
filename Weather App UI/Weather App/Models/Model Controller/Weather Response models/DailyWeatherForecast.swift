//
//  dailyWeatherForecast.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

struct DailyWeatherForcast: Decodable {
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
    let weather: [WeatherObservation]
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
        weather = try container.decode([WeatherObservation].self, forKey: .weather)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        windDirection = try container.decode(Int.self, forKey: .windDirection)
    }
}
