//
//  LocationCollections.swift
//  Weather App
//
//  Created by Andrew CP Markham on 18/9/20.
//

import Foundation

class LocationCollection: Codable{
    //Singleton: idea being that regardless of mutli screen, there should be only one instance of collections
    static let shared =  LocationCollection()
    
    private var locations: [Location] = []{
        didSet{
            LocationCollection.saveToFile(locations: locations).self
        }
    }
    
    //Default locations for saving of data
    private static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archiveURL = documentsDirectory.appendingPathComponent("locations").appendingPathExtension("plist")
    
    private init() {
        locations += LocationCollection.loadFromFile().isEmpty ? loadDefaultLocations() : LocationCollection.loadFromFile()
    }
    
    private func loadDefaultLocations() -> [Location] {
        return [
            Location(id: 2759794, city: "Amsterdam", country: "Netherlands", lat: 52.37, lon: 4.89),
            Location(id: 3128760, city: "Barcelona", country: "Spain", lat: 41.39, lon: 2.16),
            Location(id: 1816670, city: "Beijing", country: "China", lat: 39.91, lon: 116.4),
            Location(id: 2950158, city: "Berlin", country: "Germany", lat: 54.03, lon: 10.45),
            Location(id: 292223, city: "Dubai", country: "United Arab Emirates", lat: 25.26, lon: 55.3),
            Location(id: 2964574, city: "Dublin", country: "Ireland", lat: 53.34, lon: -6.27),
            Location(id: 2643743, city: "London", country: "United Kingdom", lat: 51.51, lon: -0.13),
            Location(id: 5368361, city: "Los Angeles", country: "United States", lat: 34.05, lon: -118.24),
            Location(id: 6359304, city: "Madrid", country: "Spain", lat: 40.49, lon: -3.68),
            Location(id: 524894, city: "Moscow", country: "Russia", lat: 55.76, lon: 37.61),
            Location(id: 5128638, city: "New York", country: "United States", lat: 43, lon: -75.5),
            Location(id: 6455259, city: "Paris", country: "France", lat: 48.86, lon: 2.35),
            Location(id: 2153391, city: "Perth", country: "Australia", lat: -41.57, lon: 147.17),
            Location(id: 3169070, city: "Rome", country: "Italy", lat: 41.89, lon: 12.48),
            Location(id: 5391959, city: "San Francisco", country: "United States", lat: 37.77, lon: -122.42),
            Location(id: 1850147, city: "Tokyo", country: "Japan", lat: 35.69, lon: 139.69),
            Location(id: 6167865, city: "Toronto", country: "Canada", lat: 43.7, lon: -79.42),
            Location(id: 2147714, city: "Sydney", country: "Australia", lat: -33.87, lon: 151.21),
            Location(id: 1622846, city: "Ubud", country: "Indonesia", lat: -8.51, lon: 115.27),
            Location(id: 2179537, city: "Wellington", country: "New Zealand", lat: -41.29, lon: 174.78)
        ]
        
    }
    
    func AddLocation(location: Location) {
        //Only add unique locations
        if !locations.contains(location){
            locations.append(location)
            locations.sort()
        }
    }
    
    func getLocationsCount() -> Int {
        return locations.count
    }
        
    func getLocationAtIndex(index: Int) -> Location {
        return locations[index]
    }
    
    static func saveToFile(locations: [Location]){
        //Function to save data to file
        let propertyListEncoder = PropertyListEncoder()
        let encodedEmoji = try? propertyListEncoder.encode(locations)
            
        try? encodedEmoji?.write(to: archiveURL, options: .noFileProtection)
    }
        
    static func loadFromFile() -> [Location]{
        //Function to load data to file
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedLocationData = try? Data(contentsOf: archiveURL), let decodedLocations = try? propertyListDecoder.decode(Array<Location>.self, from: retrievedLocationData){
            return decodedLocations
        }
        return []
    }
}
