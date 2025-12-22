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

        let location: Location
        let currentWeather: WeatherObservation

        var isFavourite: Bool = false
        var performedAutomaticFavouriteSegue = false
        var url: URL? = nil

        // MARK: - Inits
        init(location: Location, currenWeather: WeatherObservation) {
            self.location = location
            self.currentWeather = currenWeather

            updateUI()
        }

        func updateUI() {

            isFavourite = AppSettingsManager.shared.bool(for: AppSettingsManager.Key.isFavourite)

            url = OpenWeatherService.getIconURL(with: currentWeather.icon)
        }
    }
}
