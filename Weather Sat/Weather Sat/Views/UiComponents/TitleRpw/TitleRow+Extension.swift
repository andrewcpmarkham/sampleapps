//
//  TitleRow+Extension.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 27/12/2025.
//

import Foundation

extension TitleRow {
    
    @Observable
    final class ViewModel {
        
        let location: Location
        let forecast: ForecastType
        var isFavourite: Bool

        var city: String {
            location.city
        }
        
        init (location: Location, forecast: ForecastType, isFavourite: Bool) {
            self.location = location
            self.forecast = forecast
            self.isFavourite = isFavourite
        }
        
        func updateFavourite() {
            if
                !isFavourite,
                let favourite = Favourite.getFavourite(for: location, forecast: forecast)
            {
                AppSettingsManager.shared.encode(favourite, for: .isFavourite)
                isFavourite = true
            } else {
                AppSettingsManager.shared.clear(.isFavourite)
                isFavourite = false
            }
        }
    }
}
