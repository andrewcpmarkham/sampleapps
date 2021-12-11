//
//  Weather.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

struct WeatherResponse: Decodable {
    
    //Main data object structure returned by API
    
    let temp: Double
    let windSpeed: Double
    let windDirection: Int
    let weather: [WeatherObservation]
    let dailyWeather: [DailyWeatherForcast]
    let lon: Double
    let lat: Double
    let timezoneOffset: Int

    enum CodingKeys: String, CodingKey{
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
        weather = try currentContainer.decode([WeatherObservation].self, forKey: .weather)
        dailyWeather = try container.decode([DailyWeatherForcast].self, forKey: .daily)
        lon = try container.decode(Double.self, forKey: .lon)
        lat = try container.decode(Double.self, forKey: .lat)
        timezoneOffset = try container.decode(Int.self, forKey: .timezoneOffset)
    }
}
