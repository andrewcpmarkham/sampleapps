//
//  CityDTO.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation

struct CityDTO: Codable {
    let id: Int?
    let name: String?
    let state: String?
    let country: String?
    let coord: CoordDTO?

    enum CodingKeys: CodingKey {
        case id
        case name
        case state
        case country
        case coord
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Picking the data wanted
        id = try? container.decodeIfPresent(Int.self, forKey: .id) ?? nil
        name = try? container.decodeIfPresent(String.self, forKey: .name) ?? nil
        state = try? container.decodeIfPresent(String.self, forKey: .state) ?? nil
        country = try? container.decodeIfPresent(String.self, forKey: .country) ?? nil
        coord = try? container.decodeIfPresent(CoordDTO.self, forKey: .coord) ?? nil
    }

    init(id: Int, name: String, state: String, country: String, coord: CoordDTO) {
        self.id = id
        self.name = name
        self.state = state
        self.country = country
        self.coord = coord
    }

    func encode(to encoder: any Encoder) throws {
        guard let id else {
            throw DecodingError.valueNotFound(
                Int.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Missing  required field: id"
                )
            )
        }
        guard let name, let state, let country else {
            throw DecodingError.valueNotFound(
                String.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Missing one or more required fields: name, state, country"
                )
            )
        }
        guard let coord else {
            throw DecodingError.valueNotFound(
                CoordDTO.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Missing required field: coord"
                )
            )
        }

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(state, forKey: .state)
        try container.encode(country, forKey: .country)
        try container.encode(coord, forKey: .coord)
    }

    // MARK: - Example
    static var example: CityDTO {
        let cityDTO = CityDTO (
            id: 1,
            name: "Sydney",
            state: "NSW",
            country: "AU",
            coord: CoordDTO.example
        )
        return cityDTO
    }
}

struct CoordDTO: Codable {
    let lon: Double?
    let lat: Double?

    enum CodingKeys: CodingKey {
        case lon
        case lat
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lon = try? container.decodeIfPresent(Double.self, forKey: .lon) ?? nil
        self.lat = try? container.decodeIfPresent(Double.self, forKey: .lat) ?? nil
    }

    init (lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }

    func encode(to encoder: any Encoder) throws {
        guard let lat, let lon else {
            throw DecodingError.valueNotFound(
                Double.self,
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Missing one or more required fields: lat, lon"
                )
            )
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
    }

    // MARK: - Example
    static var example: CoordDTO {
        let coordDTO = CoordDTO (
            lat: 37.785834,
            lon: -122.406417
        )
        return coordDTO
    }
}
