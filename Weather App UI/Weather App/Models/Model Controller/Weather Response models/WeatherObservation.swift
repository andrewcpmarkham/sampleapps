//
//  WeatherObservation.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

struct WeatherObservation: Codable {
    // Sub data object structure returned by Open Weather API
    let detail: String
    let description: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case detail = "main"
        case description
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.detail = try container.decode(String.self, forKey: CodingKeys.detail)
        self.description = try container.decode(String.self, forKey: CodingKeys.description)
        self.icon = try container.decode(String.self, forKey: CodingKeys.icon)
    }

    init (
        detail: String,
        description: String,
        icon: String
    ) {
        self.detail = detail
        self.description = description
        self.icon = icon
    }

    // MARK: - Example
    static var example: WeatherObservation {
        return WeatherObservation (
            detail: "Clouds",
            description: "overcast clouds",
            icon: "04d",
        )
    }
}
