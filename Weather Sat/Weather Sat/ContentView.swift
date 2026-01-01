//
//  ContentView.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {

            LocationsView(modelContext: modelContext)
                .navigationDestination(for: Favourite.self) { favourite in

                    switch favourite {

                    case let .current(location, weatherResponseDTO, weatherObservation):
                        CurrentWeatherView(locationDTO: location,weatherResponseDTO: weatherResponseDTO, currenWeatherDTO: weatherObservation)

                    case let .day(location, weather, todaysWeather):
                        DayWeatherView(locationDTO: location, weatherDTO: weather, todaysWeatherDTO: todaysWeather)

                    case let .week(location, weather, weeksWeather):
                        WeekWeatherView(locationDTO: location, weatherDTO: weather, weeksWeatherDTO: weeksWeather)
                    }
                }
        }
        .task {
            guard let favourite = AppSettingsManager.shared.decode(Favourite.self, for: .isFavourite) else { return }
            print ("Favourite: \(favourite)")
            path = NavigationPath([favourite])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Location.self, inMemory: true)
}
