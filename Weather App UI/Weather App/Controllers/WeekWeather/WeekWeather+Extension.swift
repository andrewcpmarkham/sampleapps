//
//  WeekWeather+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

extension WeekWeather {

    @Observable
    final class ViewModel {

        var location: Location
        var isFavourite: Bool = false
        var performedAutomaticFavouriteSegue = false
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
        }

    }
}
