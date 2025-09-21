//
//  DayWeather+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

extension DayWeather {

    @Observable
    final class ViewModel {

        var location: Location
        var isFavourite: Bool = false
        var performedAutomaticFavouriteSegue = false

        var weather: WeatherResponse
        var todaysWeather: DailyWeatherForcast
        var url: URL? {
            guard let icon = todaysWeather.weather.first?.icon else {
                return nil
            }
             return GetWeatherFromAPIDelegate.getIconURL(with: icon)
        }

        var dateLabel: String {
            Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: todaysWeather.dt + weather.timezoneOffset)
            )
        }

        var highTempLabel: String {
            String(format: "%.0f", todaysWeather.tempMax) + "C"
        }

        var lowTempLabel: String {
            String(format: "%.0f", todaysWeather.tempMin) + "C"
        }

        var detailLabel: String {
            guard let detail = todaysWeather.weather.first?.detail else {
                return ""
            }
            return detail
        }

        var windDirectionLabel: String {
            "\(weather.windDirection)º"
        }

        var windSpeedLabel: String {
            String(format: "%.1f", weather.windSpeed) + "km/h"
        }

        // MARK: - Inits
        init(location: Location, weather: WeatherResponse, todaysWeather: DailyWeatherForcast) {
            self.location = location
            self.weather = weather
            self.todaysWeather = todaysWeather

            updateUI()
        }

        func updateUI() {
            // Check for favourite
            if let favourite = FavouriteController.loadFromFile(),
               favourite.location == location,
               favourite.forecast == .daily
            {
                isFavourite = true
            }
        }
    }
}
