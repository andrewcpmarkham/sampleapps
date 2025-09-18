//
//  CurrentWeather+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 1/9/2025.
//

import SwiftUI

extension CurrentWeather {

    @Observable
    final class ViewModel {

        var location: Location
        var isFavourite: Bool = false
        var performedAutomaticFavouriteSegue = false
        var url: URL? = nil

        // MARK: - Inits
        init(location: Location) {
            self.location = location

            updateUI()
        }

        func updateUI() {
            // Check for favourite
            if let favourite = FavouriteController.loadFromFile(),
               favourite.location == location,
               favourite.forecast == .current
            {
                isFavourite = true
            }

            if
                let weather = location.weather,
                let currentWeather = weather.weather.first
            {
                url = GetWeatherFromAPIDelegate.getIconURL(with: currentWeather.icon)
            }
        }
    }
}
