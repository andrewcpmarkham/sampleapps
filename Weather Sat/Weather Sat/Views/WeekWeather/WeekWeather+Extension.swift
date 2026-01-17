//
//  WeekWeather+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

extension WeekWeatherView {

    @Observable
    final class ViewModel: WeatherUpdater {

        var location: Location

        var weatherResponse: WeatherResponse
        var weeksWeather: [DailyWeatherForcast]

        var loadState: LoadState

        var dateLabel: String {
            guard let todaysWeather = weeksWeather.first else {
                return ""
            }

            return Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: todaysWeather.dt + weatherResponse.timezoneOffset)
            )
        }

        // MARK: - Inits
        init(location: Location, weatherResponse: WeatherResponse, weeksWeather: [DailyWeatherForcast], loadState: LoadState = .success("Pre loaded")) {
            self.location = location
            self.weatherResponse = weatherResponse
            self.weeksWeather = weeksWeather
            self.loadState = loadState

            if loadState == .loading || location.getDataDate() < Calendar.current.startOfDay(for: Date()) {
                Task {
                    await getLocationWeather()
                }
            }
        }

        func getLocationWeather() async {
            loadState = .loading

            do {
                let weatherDTO = try await OpenWeatherService.shared.weatherRequest(
                    cityLon: location.lon,
                    cityLat: location.lat,
                    optionalRequest: false
                )
                let latestWeatherResponse = WeatherResponse(from: weatherDTO)
                let latestWeeklyWeather = latestWeatherResponse.dailyWeather

                await MainActor.run {
                    let updatedLocation = self.location
                    updatedLocation.weather = latestWeatherResponse
                    weatherResponse = latestWeatherResponse
                    weeksWeather = latestWeeklyWeather
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
