//
//  WeatherObservationTests.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 30/12/2025.
//

import Testing
@testable import Weather_Sat

struct WeatherObservationTests {

    @Test func initToFromDTORoundTrip() async throws {
        let weatherObservation = WeatherObservation(
            detail: TestingUtilities.randomString(length: 10),
            desc: TestingUtilities.randomString(length: 10),
            icon: TestingUtilities.randomString(length: 10)
        )
        let weatherObservationDTO = WeatherObservationDTO(from: weatherObservation)
        let weatherObservationFromDTO = WeatherObservation(from: weatherObservationDTO)
        #expect(weatherObservation.detail == weatherObservationFromDTO.detail)
        #expect(weatherObservation.desc == weatherObservationFromDTO.desc)
        #expect(weatherObservation.icon == weatherObservationFromDTO.icon)
    }
}
