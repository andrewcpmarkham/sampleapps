//
//  Location.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation
import SwiftData

@Model
final class Location {

    var weather: WeatherResponse?

    var id: Int
    var city: String
    var state: String
    var country: String
    var lat: Double
    var lon: Double

    // Layout Properties
    var weatherDetailLabel: String {
        return weather?.weather.first?.detail ?? ""
    }
    var temperatureLabel: String {
        guard let temp = weather?.temp else {
            return ""
        }
        return "\(String(format: "%.0f", temp)) C"
    }
    var windDirectionLabel: String {
        guard let windDirection = weather?.windDirection else {
            return ""
        }
        return "Wind Direction: \(windDirection)º"
    }
    var windSpeedLabel: String {
        guard let windSpeed = weather?.windSpeed else {
            return ""
        }
        return "Wind Speed: \(String(format: "%.1f", windSpeed)) km/h"
    }


    init(id: Int, city: String, state: String, country: String, lat: Double, lon: Double) {
        self.id = id
        self.city = city
        self.state = state
        self.country = country
        self.lat = lat
        self.lon = lon

    }

    init?(from dto: LocationDTO) {
        guard let id = dto.id, let city = dto.city, let state = dto.state, let country = dto.country, let lat = dto.lat, let lon = dto.lon else {
            return nil
        }

        self.id = id
        self.city = city
        self.state = state
        self.country = country
        self.lat = lat
        self.lon = lon
    }

    func encode(to encoder: Encoder) throws {
        // function to encode data for saving
        let dto = LocationDTO(from: self)
        try dto.encode(to: encoder)
    }

    // MARK: - Example
    static var example: Location {
        let location = Location (
            id: 1,
            city: "Sydney",
            state: "NSW",
            country: "AU",
            lat: 37.785834,
            lon: -122.406417
        )
        location.weather = WeatherResponse(from: WeatherResponseDTO.example)
        return location
    }

    // MARK: - Functions
    func willGetWeatherForLocation() async {
        do {
            let weatherResponseDTO = try await OpenWeatherService.shared.weatherRequest(
                cityLon: self.lon,
                cityLat: self.lat,
                optionalRequest: false
            )

            self.weather = WeatherResponse(from: weatherResponseDTO)

        } catch {
            print("Weather data not obtained for \(self.city): \(error)")
        }
    }

    func cancelGetWeatherForLocation() {
        // Required for background refresh
        OpenWeatherService.shared.urlSession.invalidateAndCancel()
    }
}

// comparable protocol conformance function
extension Location: Comparable {
    static func < (lhs: Location, rhs: Location) -> Bool {
        return lhs.city < rhs.city
    }
}
