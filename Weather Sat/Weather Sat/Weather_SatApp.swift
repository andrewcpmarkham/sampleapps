//
//  Weather_SatApp.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import SwiftUI
import SwiftData

@main
struct Weather_SatApp: App {

    let container: ModelContainer

    init() {

        // Base setup for Swift Data
        let schema = Schema([
            City.self,
            Location.self,
            DailyWeatherForcast.self,
            WeatherObservation.self,
            WeatherResponse.self
        ])

        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        // Preload data from eithere seaded DBs or JSON
        if !UserDefaults.standard.hasLaunchedBefore {
            let cityDataController = CityDataController()
            do {
                // Try to load pre seeded DBs from package
                try cityDataController.seedData()
                print("Load Seeded SwiftData: Success")
            } catch {
                print("Load Seeded SwiftData: SwiftData files failed to load: \(error)")
            }

            do {
                container = try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }

            // This is really for the dev so that if you remove the sql files in the project you can populate new ones
            // Say if there was an update cities list
            preloadContextFromJSON(cityDataController: cityDataController)

        // Load for continuous use
        } else {
            do {
                container = try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }

    func preloadContextFromJSON(cityDataController: CityDataController) {
        guard !UserDefaults.standard.hasLaunchedBefore else { return }
        do {
            let ctx = container.mainContext
            ctx.autosaveEnabled = false
            try cityDataController.preloadCities(into: ctx) // <-- use ctx, not @Environment
            try ctx.save()
            UserDefaults.standard.hasLaunchedBefore = true
        } catch {
            print("JSON Data failed to load: \(error)")
        }
    }
}
