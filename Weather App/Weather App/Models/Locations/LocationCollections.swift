//
//  LocationCollections.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

class LocationCollection: Codable {
    // Singleton: idea being that regardless of mutli screen, there should be only one instance of collections
    static let shared =  LocationCollection()
    private var locations: [Location] = [] {
        didSet {
            LocationCollection.saveToFile(locations: locations).self
        }
    }
    // Default locations for saving of data
    private static let documentsDirectory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archiveURL =
        documentsDirectory.appendingPathComponent("locations").appendingPathExtension("plist")
    private init() {
        locations += LocationCollection.loadFromFile().isEmpty ?
            loadDefaultLocations() : LocationCollection.loadFromFile()
    }
    private func loadDefaultLocations() -> [Location] {
        return [
            Location(id: 2147714, city: "Sydney", state: "NSW", country: "AU", lat: -33.87, lon: 151.21),
            Location(id: 2158177, city: "Melbourne", state: "VIC", country: "AU", lat: -37.81, lon: 144.96),
            Location(id: 2174003, city: "Brisbane", state: "VIC", country: "AU", lat: -27.47, lon: 153.03)
        ]
    }
    func addLocation(location: Location) {
        // Only add unique locations
        if !locations.contains(location) {
            locations.append(location)
            locations.sort()
        }
    }
    func deleteLocation(location: Location) {
        // Only add unique locations
        if let index = locations.firstIndex(of: location) {
            locations.remove(at: index)
        }
    }

    func deleteAllLocations() {
        // Only add unique locations
        locations.removeAll()
    }
    func getLocationsCount() -> Int {
        return locations.count
    }

    func getLocationAtIndex(index: Int) -> Location? {
        return locations[index]
    }

    func willSetWeatherForLocationAtIndex(at index: Int, with weather: WeatherResponse) {
        if getLocationAtIndex(index: index) != nil {
            locations[index].weather = weather
        }
    }

    func willUpdateWeatherForLocations() {
        for location in locations {
            location.willGetWeatherForLocation()
        }
    }

    func willCancelUpdateWeatherForLocations() {
        for location in locations {
            location.cancelGetWeatherForLocation()
        }
    }
    static func saveToFile(locations: [Location]) {
        // Function to save data to file
        let propertyListEncoder = PropertyListEncoder()
        let encodedEmoji = try? propertyListEncoder.encode(locations)
        try? encodedEmoji?.write(to: archiveURL, options: .noFileProtection)
    }
    static func loadFromFile() -> [Location] {
        // Function to load data to file
        let propertyListDecoder = PropertyListDecoder()
        if
            let retrievedLocationData = try? Data(contentsOf: archiveURL),
            let decodedLocations = try? propertyListDecoder.decode(Array<Location>.self, from: retrievedLocationData) {
            return decodedLocations
        }
        return []
    }
}
