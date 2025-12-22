//
//  WeekWeather+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

extension WeekWeatherView {

    @Observable
    final class ViewModel {

        let location: Location
        var isFavourite: Bool = false
        var performedAutomaticFavouriteSegue = false
        let weather: WeatherResponse
        let weeksWeather: [DailyWeatherForcast]

        var dateLabel: String {
            guard let todaysWeather = weeksWeather.first else {
                return ""
            }

            return Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: todaysWeather.dt + weather.timezoneOffset)
            )
        }

        // MARK: - Inits
        init(location: Location, weather: WeatherResponse, weeksWeather: [DailyWeatherForcast]) {
            self.location = location
            self.weather = weather
            self.weeksWeather = weeksWeather

            updateUI()
        }

        func updateUI() {
            // Check for favourite
            isFavourite = AppSettingsManager.shared.bool(for: AppSettingsManager.Key.isFavourite)
        }

    }
}
