//
//  Favourite.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 24/12/2025.
//

import Foundation
import SwiftUI

enum ForecastType: String, Codable, Hashable {
    case current
    case day
    case week
}

/// Represents a user-selected favourite forecast for a specific location.
/// - Note:
///   `Favourite` intentionally stores DTO types rather than domain models to
///   utilise  encoding, decoding  and long-term persistence.
enum Favourite: Hashable, Codable, Equatable {
    case current(location: LocationDTO, weatherObservation: WeatherObservationDTO)
    case day(location: LocationDTO, weatherResponse: WeatherResponseDTO, dailyWeatherForcast: DailyWeatherForcastDTO)
    case week(location: LocationDTO, weatherResponse: WeatherResponseDTO, dailyWeatherForcasts: [DailyWeatherForcastDTO])

    static func == (lhs: Favourite, rhs: Favourite) -> Bool {
        switch (lhs, rhs) {
        case (.current, .current),
            (.day, .day),
            (.week, .week):
            return true
        default:
            return false
        }
    }
    
    /// Determines whether a given location and forecast type matches the saved favourite.
    /// - Parameters:
    ///   - location: The `Location` to compare against the saved favourite.
    ///   - forecast: The forecast type being queried.
    /// - Returns: `true` if the provided location and forecast type match the saved
    ///   favourite; otherwise, `false`.
    static func isFavourite(location: Location, forecast: ForecastType) -> Bool {
        guard let favourite = AppSettingsManager.shared.decode(Favourite.self, for: .isFavourite) else {
            return false
        }
        switch favourite {
        case .current(location: let favLocation, weatherObservation: _):
            return location.id == favLocation.id && forecast == .current
        case .day(location: let favLocation, weatherResponse: _, dailyWeatherForcast: _):
            return location.id == favLocation.id && forecast == .day
        case .week(location: let favLocation, weatherResponse: _, dailyWeatherForcasts: _):
            return location.id == favLocation.id && forecast == .current
        }
    }
    
    /// Creates a `Favourite` representation for a given `Location` and forecast type.
    /// - Parameters:
    ///   - location: The `Location` from which the favourite is created.
    ///   - forecast: The type of forecast to create a favourite for.
    /// - Returns: A `Favourite` matching the requested forecast type, or `nil` if
    ///   the required weather data is missing.
    static func getFavourite(for location: Location, forecast: ForecastType) -> Favourite? {
        let locationDTO = LocationDTO(from: location)
        switch forecast {
            case .current:
            guard let currentWeather = location.weather?.weather.first else {
                return nil
            }
            let currentWeatherDTO = WeatherObservationDTO(from: currentWeather)
            return Favourite.current(location: locationDTO, weatherObservation: currentWeatherDTO)
        case .day:
            guard
                let weatherResonse = location.weather,
                let dayWeather = location.weather?.dailyWeather.first
            else {
                return nil
            }
            let weatherResonseDTO = WeatherResponseDTO(from: weatherResonse)
            let dayWeatherDTO = DailyWeatherForcastDTO(from: dayWeather)
            return Favourite.day(location: locationDTO, weatherResponse: weatherResonseDTO, dailyWeatherForcast: dayWeatherDTO)
        case .week:
            guard
                let weatherResonse = location.weather,
                let weeksWeather = location.weather?.dailyWeather
            else {
                return nil
            }
            let weatherResonseDTO = WeatherResponseDTO(from: weatherResonse)
            let weeksWeatherDTO = weeksWeather.compactMap{DailyWeatherForcastDTO(from: $0)}
            return Favourite.week(location: locationDTO, weatherResponse: weatherResonseDTO, dailyWeatherForcasts: weeksWeatherDTO)
        }
    }
}
