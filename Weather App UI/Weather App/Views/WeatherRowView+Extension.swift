//
//  WeatherRowView+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 21/9/2025.
//

import SwiftUI

extension WeatherRowView {

    @Observable
    final class ViewModel {

        var weather: WeatherResponse
        var dailyWeatherForcast: DailyWeatherForcast
        var url: URL? {
            guard let icon = dailyWeatherForcast.weather.first?.icon else {
                return nil
            }
             return GetWeatherFromAPIDelegate.getIconURL(with: icon)
        }

        var dateLabel: String {
            Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: dailyWeatherForcast.dt + weather.timezoneOffset)
            )
        }

        var highTempLabel: String {
            String(format: "%.0f", dailyWeatherForcast.tempMax) + "C"
        }

        var lowTempLabel: String {
            String(format: "%.0f", dailyWeatherForcast.tempMin) + "C"
        }

        var detailLabel: String {
            guard let detail = dailyWeatherForcast.weather.first?.detail else {
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
        init(weather: WeatherResponse, dailyWeatherForcast: DailyWeatherForcast) {
            self.weather = weather
            self.dailyWeatherForcast = dailyWeatherForcast
        }
    }
}
