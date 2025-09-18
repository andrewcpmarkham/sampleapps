//
//  Locations.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

/**
 Main dataobject used within apps concerning city data from API and cities data in coredata
*/
class Location: Equatable, Comparable {

    // swiftlint:disable:next weak_delegate
    var getWeatherFromAPIDelegate = GetWeatherFromAPIDelegate()
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
        return Location (
            id: 1,
            city: "Sydney",
            state: "NSW",
            country: "AU",
            lat: 37.785834,
            lon: -122.406417
        )
    }
}

// equitable protocol conformance function
extension Location {
    static func == (lhs: Location, rhs: Location) -> Bool {

        return lhs.id == rhs.id
    }
}

// comparable protocol conformance function
extension Location {
    static func < (lhs: Location, rhs: Location) -> Bool {
        return lhs.city < rhs.city
    }
}

// Enable weather update
extension Location {
    func willGetWeatherForLocation() {
        getWeatherFromAPIDelegate.weatherRequest(cityLon: lon, cityLat: lat, optionalRequest: false,
            completion: { (weather, _) in
            guard let weather = weather else {
                return
            }

            DispatchQueue.main.async {
                self.weather = weather
            }
        })
    }

    func cancelGetWeatherForLocation() {
        // Required for background refresh
        getWeatherFromAPIDelegate.urlSession.invalidateAndCancel()
    }
}

