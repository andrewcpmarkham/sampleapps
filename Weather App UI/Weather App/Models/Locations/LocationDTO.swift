//
//  LocationDTO.swift
//  Weather App
//
//  Created by Andrew CP Markham on 3/9/2025.
//

import Foundation

struct LocationDTO: Codable {
    var id: Int?
    var city: String?
    var state: String?
    var country: String?
    var lat: Double?
    var lon: Double?

    private enum WeatherAPIDecodingKeys: String, CodingKey {

        case id
        case city = "name"
        case sys
        case coord
    }

    private enum SysKeys: String, CodingKey {
        case country
    }

    private enum LocationsJSONdecodingkeys: String, CodingKey {

        case id
        case city = "name"
        case state
        case country
        case coord
    }

    private enum CoordKeys: String, CodingKey {
        case lat
        case lon
    }

    private enum CodingKeys: String, CodingKey {

        case id
        case city
        case state
        case country
        case coord
        case lat
        case lon
    }

    init(from decoder: Decoder) throws {
        // Decoder for local saved state
        let containerForSavedState = try decoder.container(keyedBy: CodingKeys.self)
        id = try containerForSavedState.decodeIfPresent(Int.self, forKey: .id)
        city = try containerForSavedState.decodeIfPresent(String.self, forKey: .city)
        state = try containerForSavedState.decodeIfPresent(String.self, forKey: .state)
        country = try containerForSavedState.decodeIfPresent(String.self, forKey: .country)
        lon = try containerForSavedState.decodeIfPresent(Double.self, forKey: .lon)
        lat = try containerForSavedState.decodeIfPresent(Double.self, forKey: .lat)

        // Decoded when stored internally in flat structure
        if id != nil && city != nil  && country != nil && lon != nil && lat != nil {
            return
        }

        // Read in From JSON File - Decoder
        let containerForJSONData = try decoder.container(keyedBy: LocationsJSONdecodingkeys.self)
        // Now pick the pieces you want
        id = try containerForJSONData.decodeIfPresent(Int.self, forKey: .id)
        city = try containerForJSONData.decodeIfPresent(String.self, forKey: .city)
        state = try containerForJSONData.decodeIfPresent(String.self, forKey: .state)
        country = try containerForJSONData.decodeIfPresent(String.self, forKey: .country)
        let coordContainer2 = try containerForJSONData.nestedContainer(keyedBy: CoordKeys.self, forKey: .coord)
        lon = try coordContainer2.decodeIfPresent(Double.self, forKey: .lon)
        lat = try coordContainer2.decodeIfPresent(Double.self, forKey: .lat)

        if id == nil || city == nil || state == nil || country == nil || lon == nil || lat == nil {
            fatalError("Decoding Error")
        }
    }

    init (from location: Location) {
        self.id = location.id
        self.city = location.city
        self.state = location.state
        self.country = location.country
        self.lat = location.lat
        self.lon = location.lon
    }

    func encode(to encoder: Encoder) throws {
        // function to encode data for saving
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(country, forKey: .country)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
    }
}
