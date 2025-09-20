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
        var url: URL? = nil

        var weather: WeatherResponse? {
            return location.weather
        }
        var todaysWeather: DailyWeatherForcast? {
            return location.weather?.dailyWeather[1] ?? nil
        }

        var dateLabel: String {
            guard let weather = weather, let todaysWeather = todaysWeather else {
                return ""
            }

            return Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: todaysWeather.dt + weather.timezoneOffset)
            )
        }

        var highTempLabel: String {
            guard let todaysWeather else {
                return ""
            }
            return String(format: "%.0f", todaysWeather.tempMax) + "C"
        }

        var lowTempLabel: String {
            guard let todaysWeather else {
                return ""
            }
            return String(format: "%.0f", todaysWeather.tempMin) + "C"
        }

        var detailLabel: String {
            guard let detail = todaysWeather?.weather.first?.detail else {
                return ""
            }
            return detail
        }

        var windDirectionLabel: String {
            guard let weather else {
                return ""
            }
            return "\(weather.windDirection)º"
        }

        var windSpeedLabel: String {
            guard let weather else {
                return ""
            }
            return String(format: "%.1f", weather.windSpeed) + "km/h"
        }

        // MARK: - Inits
        init(location: Location) {
            self.location = location

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

            if
                let icon = todaysWeather?.weather.first?.icon
            {
                url = GetWeatherFromAPIDelegate.getIconURL(with: icon)
            }
        }
    }
}
