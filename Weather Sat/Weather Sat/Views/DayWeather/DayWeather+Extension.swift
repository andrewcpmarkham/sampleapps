//
//  DayWeather+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

extension DayWeatherView {

    @Observable
    final class ViewModel {

        var location: Location
        var isFavourite: Bool = false

        var weatherResponse: WeatherResponse
        var dayWeather: DailyWeatherForcast

        var loadState: LoadState

        var url: URL? {
            guard let icon = dayWeather.weather.first?.icon else {
                return nil
            }
             return OpenWeatherService.getIconURL(with: icon)
        }

        var dateLabel: String {
            Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: dayWeather.dt + weatherResponse.timezoneOffset)
            )
        }

        var highTempLabel: String {
            String(format: "%.0f", dayWeather.tempMax) + "C"
        }

        var lowTempLabel: String {
            String(format: "%.0f", dayWeather.tempMin) + "C"
        }

        var detailLabel: String {
            guard let detail = dayWeather.weather.first?.detail else {
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
        init(location: Location, weatherResponse: WeatherResponse, dayWeather: DailyWeatherForcast, loadState: LoadState = .success("Pre loaded")) {
            self.location = location
            self.weatherResponse = weatherResponse
            self.dayWeather = dayWeather
            self.isFavourite = Favourite.isFavourite(location: location, forecast: .day)
            self.loadState = loadState

            if loadState == .loading {
                Task {
                    await getLocationWeather()
                }
            }
        }

        private func getLocationWeather() async {
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
                    dayWeather = latestDailyWeather
                    loadState = .success("Weather Updated")
                }
            } catch {
                await MainActor.run {
                    loadState = .error("Failed to fetch weather: \(error)")
                }
            }
        }
    }
}
