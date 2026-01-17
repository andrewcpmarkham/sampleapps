//
//  WeatherRowView+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 21/9/2025.
//

import SwiftUI

extension WeatherRowView {

    @Observable
    final class ViewModel: WeatherIconUpdater {
        
        var location: Location

        var weatherResponse: WeatherResponse
        var dailyWeatherForcast: DailyWeatherForcast

        var loadState: LoadState

        var iconURL: URL?

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
        init(location: Location, weatherResponse: WeatherResponse, dailyWeatherForcast: DailyWeatherForcast, loadState: LoadState = .success("Pre loaded")) {
            self.location = location
            self.weatherResponse = weatherResponse
            self.dailyWeatherForcast = dailyWeatherForcast
            self.loadState = loadState

            if loadState == .loading {
                Task {
                    await getLocationWeather()
                    UpdateIcon()
                }
            } else {
                UpdateIcon()
            }
        }

        // MARK: - Functions
        func getLocationWeather() async {
            loadState = .loading

            do {
                let weatherDTO = try await OpenWeatherService.shared.weatherRequest(
                    cityLon: location.lon,
                    cityLat: location.lat,
                    optionalRequest: false
                )
                let latestWeather = WeatherResponse(from: weatherDTO)
                guard let latestDailyWeather = latestWeather.dailyWeather.first else {
                    loadState = .error("Failed to fetch latest days weather")
                    return
                }

                await MainActor.run {
                    let updatedLocation = self.location
                    updatedLocation.weather = latestWeather
                    weatherResponse = latestWeather
                    dailyWeatherForcast = latestDailyWeather
                    loadState = .success("Weather Updated")
                }
            } catch {
                await MainActor.run {
                    loadState = .error("Failed to fetch weather: \(error)")
                }
            }
        }

        /// Function to update the icon of the weather
        func UpdateIcon() {
            guard let weatherIconURL = dailyWeatherForcast.weather.first?.icon else {
                return
            }
            self.iconURL =  OpenWeatherService.getIconURL(with: weatherIconURL)
        }
    }
}
