//
//  CurrentWeather+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 1/9/2025.
//

import SwiftUI

extension CurrentWeatherView {

    @Observable
    final class ViewModel {

        var location: Location
        var isFavourite: Bool
        var currentWeather: WeatherObservation
        var iconURL: URL? = nil

        var loadState: LoadState

        // MARK: - Inits
        init(location: Location, currenWeather: WeatherObservation, loadState: LoadState = .success("Pre loaded")) {
            self.location = location
            self.currentWeather = currenWeather
            self.isFavourite = Favourite.isFavourite(location: location, forecast: .current)
            self.loadState = loadState

            if loadState == .loading {
                Task {
                    await getLocationWeather()
                    updateUI()
                }
            } else {
                updateUI()
            }
        }

        func updateUI() {
            iconURL = OpenWeatherService.getIconURL(with: currentWeather.icon)
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
                guard let latestCurrentWeather = latestWeather.weather.first else {
                    loadState = .error("Failed to fetch latest current weather")
                    return
                }

                await MainActor.run {
                    let updatedLocation = self.location
                    updatedLocation.weather = latestWeather
                    currentWeather = latestCurrentWeather
                    loadState = .success("Weather Updated")
                }
                updateUI()
            } catch {
                await MainActor.run {
                    loadState = .error("Failed to fetch weather: \(error)")
                }
            }
        }
    }
}
