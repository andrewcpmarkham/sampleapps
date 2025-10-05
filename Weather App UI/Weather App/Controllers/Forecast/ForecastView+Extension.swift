//
//  ForecastView+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 25/9/2025.
//

import Foundation

extension ForecastView {

    @Observable
    final class ViewModel {
        var location: Location
        var weather: WeatherResponse

        var currentWeather: WeatherObservation?
        var dayWeather: DailyWeatherForcast?
        var weekWeather: [DailyWeatherForcast]?

        var title: String { "\(location.city), \(location.country)"}

        enum ForecastKey: String, CaseIterable {
            case currentWeather
            case dayWeather
            case weekWeather

            var label: String {
                switch self {
                case .currentWeather:
                    return "Current Weather"
                case .dayWeather:
                    return "24-hour Forecast"
                case .weekWeather:
                    return "7-day Forecast"
                }
            }
        }

        // MARK: - Inits
        init(location: Location, weather: WeatherResponse) {
            self.location = location
            self.weather = weather
            self.currentWeather = weather.weather.first
            self.dayWeather = weather.dailyWeather.first
            self.weekWeather = weather.dailyWeather

            updateUI()
        }

        func updateUI() {
            // Check for favourite

        }
    }
}
