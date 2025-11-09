//
//  WeatherObervation.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation
import SwiftData

@Model
final class WeatherObservation {
    // Sub data object structure returned by Open Weather API
    var detail: String
    var desc: String
    var icon: String

    init (from dto: WeatherObservationDTO) {
        self.detail = dto.detail
        self.desc = dto.desc
        self.icon = dto.icon
    }

    init (
        detail: String,
        desc: String,
        icon: String
    ) {
        self.detail = detail
        self.desc = desc
        self.icon = icon
    }

    // MARK: - Example
    static var example: WeatherObservation {
        return WeatherObservation (
            detail: "Clouds",
            desc: "overcast clouds",
            icon: "04d",
        )
    }
}

