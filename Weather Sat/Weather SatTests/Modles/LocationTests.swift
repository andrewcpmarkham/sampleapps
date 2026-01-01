//
//  LocationTests.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 30/12/2025.
//

import Foundation
import Testing
@testable import Weather_Sat


struct LocationTests {

    enum TypeError: Error, LocalizedError {
        case conversionFailed

        var errorDescription: String {
            switch self {
            case .conversionFailed:
                return "Location object creation failed for DTO when it should have succeeded!"
            }
        }
    }

    @Test func initToFromDTORoundTrip() async throws {
        let location = Location(
            id: Int.random(in: 0...100),
            city: TestingUtilities.randomString(length: 10),
            state: TestingUtilities.randomString(length: 10),
            country: TestingUtilities.randomString(length: 10),
            lat: Double.random(in: 0...100),
            lon: Double.random(in: 0...100)
        )

        let locationDTO = LocationDTO(from: location)
        guard let locationFromDTO = Location(from: locationDTO) else {
            throw TypeError.conversionFailed
        }
        #expect(location.id == locationFromDTO.id)
        #expect(location.city == locationFromDTO.city)
        #expect(location.state == locationFromDTO.state)
        #expect(location.country == locationFromDTO.country)
        #expect(location.lat == locationFromDTO.lat)
        #expect(location.lon == locationFromDTO.lon)
    }
}
