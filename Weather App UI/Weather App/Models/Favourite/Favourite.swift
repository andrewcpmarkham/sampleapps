//
//  FavouriteController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/9/2025.
//

import SwiftData
import Foundation

/// Data Model for the actual type
struct Favourite: Codable, Equatable {
    let location: Location
    let forecast: Forecast

    enum TypeError: Error, LocalizedError {
        case favouriteNotFound

        var errorDescription: String? {
            switch self {
            case .favouriteNotFound:
                return "No favourite was returned from storage."
            }
        }
    }

    enum Forecast: String, CodingKey, Codable {
        case current
        case hourly
        case daily
    }

    private enum CodingKeys: String, CodingKey {
        case location
        case forecast
    }

    init (location: Location, forecast: Forecast) {
        self.location = location
        self.forecast = forecast
    }

    init(from decoder: Decoder) throws {

        // Decoder for local saved state
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let locationDTO = try container.decode(LocationDTO.self, forKey: .location)

        guard let location = Location(from: locationDTO) else {throw TypeError.favouriteNotFound}
        let forecast = try container.decode(Forecast.self, forKey: .forecast)

        self.location = location
        self.forecast = forecast
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dto = LocationDTO(from: location)

        try container.encode(dto, forKey: .location)
        try container.encode(forecast, forKey: .forecast)
    }
}

