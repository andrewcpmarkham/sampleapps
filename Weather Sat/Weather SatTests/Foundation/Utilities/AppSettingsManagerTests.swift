//
//  AppSettingsManagerTests.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 25/11/2025.
//

import Foundation
import Testing
@testable import Weather_Sat

struct AppSettingsManagerTests {

    // Unit test:
    let testSettings = AppSettingsManager(defaults: UserDefaults(suiteName: "TestSuite")!)

    @Test func boolSetGet() async throws {
        #expect(try testSettings.bool(for: .isFavourite) == false)
        await testSettings.set(true, for: AppSettingsManager.Key.isFavourite)
        #expect(try testSettings.bool(for: .isFavourite) == true)
        await testSettings.set(false, for: AppSettingsManager.Key.isFavourite)
        #expect(try testSettings.bool(for: .isFavourite) == false)
    }

    @Test func dateSetGet() async throws {
        // Write your test here when appropriate key exists
    }

    @Test func stringSetGet() async throws {
        // Write your test here when appropriate key exists
    }

    @Test func dataSetGet() async throws {
        // Write your test here when appropriate key exists
    }

    @Test func codableSetGet() async throws {
        // Write your test here when appropriate key exists
    }
}
