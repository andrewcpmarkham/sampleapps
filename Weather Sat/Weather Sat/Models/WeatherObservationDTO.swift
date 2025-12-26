//
//  WeatherObservationDTO.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import Foundation

nonisolated struct WeatherObservationDTO: Hashable, Codable {
    // Sub data object structure returned by Open Weather API
    let detail: String
    let desc: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case detail = "main"
        case description
        case icon
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

    init(from weatherObservation: WeatherObservation) {
        self.detail = weatherObservation.detail
        self.desc = weatherObservation.desc
        self.icon = weatherObservation.icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.detail = try container.decode(String.self, forKey: CodingKeys.detail)
        self.desc = try container.decode(String.self, forKey: CodingKeys.description)
        self.icon = try container.decode(String.self, forKey: CodingKeys.icon)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(detail, forKey: .detail)
        try container.encode(desc, forKey: .description)
        try container.encode(icon, forKey: .icon)
    }

    // MARK: - Example
    static var example: WeatherObservationDTO {
        return WeatherObservationDTO (
            detail: "Clouds",
            desc: "overcast clouds",
            icon: "04d",
        )
    }
}
