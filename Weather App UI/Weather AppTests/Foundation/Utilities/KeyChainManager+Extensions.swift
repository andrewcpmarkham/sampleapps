//
//  KeyChainManager+Extensions.swift
//  Weather AppTests
//
//  Created by Andrew CP Markham on 4/10/2025.
//

import Foundation
import Testing
@testable import Weather_App

struct KeyChainManager_Extensions {

    let service = KeychainManager.Service.mockWeather

    // Tests both get and save API key
    @Test func testSaveAndGetAPIKey() async throws {
        let sutAPIKey = UUID().uuidString

        // cleanup
        try await KeychainManager.shared.deleteAPIKey(service: service)

        // First call should throw, since nothing saved yet
        await #expect(throws: KeychainError.apiKeyNotFound) {
            try await KeychainManager.shared.getAPIKey(service: service)
        }

        // Save
        try await KeychainManager.shared.saveAPIKey(sutAPIKey, service: service)

        // Now it should succeed
        let recoveredKey = try await KeychainManager.shared.getAPIKey(service: service)

        // Check round-trip
        #expect(recoveredKey == sutAPIKey)

        // cleanup
        try await KeychainManager.shared.deleteAPIKey(service: service)
    }

    // Test Chaning key Works
    @Test func changeAPIKey() async throws {
        let sutAPIKey = UUID().uuidString
        let updatedAPIKey = UUID().uuidString

        // cleanup
        try await KeychainManager.shared.deleteAPIKey(service: service)

        // Save New and Check
        try await KeychainManager.shared.saveAPIKey(sutAPIKey, service: service)
        let recoveredKey = try await KeychainManager.shared.getAPIKey(service: service)
        #expect(recoveredKey == sutAPIKey)

        // Update
        try await KeychainManager.shared.saveAPIKey(updatedAPIKey, service: service)
        let recoveredUpdateKey = try await KeychainManager.shared.getAPIKey(service: service)
        #expect(recoveredUpdateKey == updatedAPIKey)

        // cleanup
        try await KeychainManager.shared.deleteAPIKey(service: service)
    }

    // Tests both delete and save API key
    @Test func deleteAPIKey() async throws {
        // cleanup
        try await KeychainManager.shared.deleteAPIKey(service: service)

        let sutAPIKey = UUID().uuidString
        try await KeychainManager.shared.saveAPIKey(sutAPIKey, service: service)
        let recoveredKey = try await KeychainManager.shared.getAPIKey(service: service)
        #expect(recoveredKey == sutAPIKey)

        // Delete Key
        try await KeychainManager.shared.deleteAPIKey(service: service)

        // Test its removed
        await #expect(throws: KeychainError.apiKeyNotFound) {
            try await KeychainManager.shared.getAPIKey(service: service)
        }
    }


}

