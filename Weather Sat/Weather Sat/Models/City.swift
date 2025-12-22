//
//  City.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation
import SwiftData

@Model
final class City {
    var id: Int
    var name: String
    var state: String
    var country: String
    var coord: Coord

    /// Cleans up the loose DTO to a set type or returns nothing
    init(from dto: CityDTO) throws {
        guard let id = dto.id,
              let name = dto.name,
              let state = dto.state,
              let country = dto.country,
              let coordDTO = dto.coord,
              let coord = Coord(from: coordDTO)
        else {
            throw DecodingError.valueNotFound(
                CityDTO.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Missing one or more required fields: id, name, state, country, coord"
                )
            )
        }
        
        self.id = id
        self.name = name
        self.state = state
        self.country = country
        self.coord = coord
    }

    init(id: Int, name: String, state: String, country: String, coord: Coord) {
        self.id = id
        self.name = name
        self.state = state
        self.country = country
        self.coord = coord
    }

    // MARK: - Example
    static var example: City {
        let city = City (
            id: 1,
            name: "Sydney",
            state: "NSW",
            country: "AU",
            coord: Coord.example
        )
        return city
    }
}

extension City: Comparable {
    static func < (lhs: City, rhs: City) -> Bool {
        lhs.name < rhs.name && lhs.country < rhs.country
    }
}

@Model
final class Coord {
    var lon: Double
    var lat: Double

    /// Cleans up the loose DTO to a set type or returns nothing
    init?(from dto: CoordDTO) {
        guard let lon = dto.lon, let lat = dto.lat else {
            return nil
        }
        self.lon = lon
        self.lat = lat
    }

    init (lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }

    // MARK: - Example
    static var example: Coord {
        let coord = Coord (
            lat: 37.785834,
            lon: -122.406417
        )
        return coord
    }
}
