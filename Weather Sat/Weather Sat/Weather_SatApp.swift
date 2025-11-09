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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Location.self,
            DailyWeatherForcast.self,
            WeatherObservation.self,
            WeatherResponse.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
