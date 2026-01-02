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

        var weatherResponse: WeatherResponse
        var dailyWeatherForcast: DailyWeatherForcast
        var url: URL? {
            guard let icon = dailyWeatherForcast.weather.first?.icon else {
                return nil
            }
             return OpenWeatherService.getIconURL(with: icon)
        }

        var dateLabel: String {
            Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: dailyWeatherForcast.dt + weatherResponse.timezoneOffset)
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
            "\(weatherResponse.windDirection)º"
        }

        var windSpeedLabel: String {
            String(format: "%.1f", weatherResponse.windSpeed) + "km/h"
        }

        // MARK: - Inits
        init(weatherResponse: WeatherResponse, dailyWeatherForcast: DailyWeatherForcast) {
            self.weatherResponse = weatherResponse
            self.dailyWeatherForcast = dailyWeatherForcast
        }
    }
}
