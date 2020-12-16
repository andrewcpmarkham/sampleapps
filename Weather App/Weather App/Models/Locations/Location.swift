//
//  Locations.swift
//  Weather App
//
//  Created by Andrew CP Markham on 18/9/20.
//

import Foundation

struct Location: Equatable, Comparable, Codable {
    
    var id: Int?
    var city: String?
    var country: String?
    var lat: Double?
    var lon: Double?
    
    private enum WeatherAPIDecodingKeys: String, CodingKey{
        case id
        case city = "name"
        case sys
        case coord
    }
    
    private enum SysKeys: String, CodingKey{
        case country
    }
    
    private enum CoordKeys: String, CodingKey{
        case lat
        case lon
    }
    
    private enum CodingKeys: String, CodingKey{
        case id
        case city
        case country
        case coord
        case lat
        case lon
    }
    
    init(id: Int, city: String, country: String, lat: Double, lon: Double) {
        self.id = id
        self.city = city
        self.country = country
        self.lat = lat
        self.lon = lon
    }
    
    init(from decoder: Decoder) throws {
        
        //Decoder for local saved state
        let containerForSavedState = try decoder.container(keyedBy: CodingKeys.self)
        id = try containerForSavedState.decodeIfPresent(Int.self, forKey: .id)
        city = try containerForSavedState.decodeIfPresent(String.self, forKey: .city)
        country = try containerForSavedState.decodeIfPresent(String.self, forKey: .country)
        lon = try containerForSavedState.decodeIfPresent(Double.self, forKey: .lon)
        lat = try containerForSavedState.decodeIfPresent(Double.self, forKey: .lat)
        
        //Decoded
        if let _ = id, let _ = city, let _ = country, let _ = lon, let _ = lat {
            return
        }
        
        //API Decoding Keys
        let containerForWeatherAPI = try decoder.container(keyedBy: WeatherAPIDecodingKeys.self)

        // Now pick the pieces you want
        id = try containerForWeatherAPI.decodeIfPresent(Int.self, forKey: .id)
        city = try containerForWeatherAPI.decodeIfPresent(String.self, forKey: .city)
        
        let sysContainer = try containerForWeatherAPI.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        country = try sysContainer.decodeIfPresent(String.self, forKey: .country)
        
        let coordContainer = try containerForWeatherAPI.nestedContainer(keyedBy: CoordKeys.self, forKey: .coord)
        lon = try coordContainer.decodeIfPresent(Double.self, forKey: .lon)
        lat = try coordContainer.decodeIfPresent(Double.self, forKey: .lat)
        
        //Still not decoded
        guard let _ = id, let _ = city, let _ = country, let _ = lon, let _ = lat else{
            fatalError("Decoding Error")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        //function to encode data for saving
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        //equitable protocol conformance function
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Location, rhs: Location) -> Bool {
        //comparable protocol conformance function
        if let lhscity = lhs.city, let rhscity = rhs.city{
            return lhscity < rhscity
        }else{
            return true
        }
        
    }
}
