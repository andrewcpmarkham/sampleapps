//
//  AddLocationSheet+Extensions.swift
//  Weather App
//
//  Created by Andrew CP Markham on 13/10/2025.
//

import Foundation
import SwiftData

extension AddLocationSheet {

    @Observable
    final class ViewModel {

        let modelContext: ModelContext
        var cities: [City] = []
        var citiesSelected: [City] = []

        var title: String { "Add Location" }
        private var lastSearchText = ""
        var searchText: String = "" {
            didSet {
                if searchText != lastSearchText {
                    lastSearchText = searchText
                    loadCities()
                }
            }
        }

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            loadCities()
        }

        func fetchMatchingCities(with searchTerm: String?) {

            do {
                var descriptor: FetchDescriptor<City>
                if searchText.isEmpty {
                    descriptor = FetchDescriptor<City>(sortBy: [])
                } else {
                    let cityPredicate = #Predicate<City> { city in
                        city.name.localizedStandardContains(searchText)
                    }
                    descriptor = FetchDescriptor<City>(predicate: cityPredicate, sortBy: [])
                }
                let storedCities = try modelContext.fetch(descriptor)
                cities = storedCities.sorted()
            } catch {
                print("Fetch failed: \(error)")
            }
        }

        /// Functions to load locations to from CoreData
        func loadCities() {
            // Plan is to have the core data preloaded so this is never called
            let searchText: String? = self.searchText.isEmpty ? nil : self.searchText
            fetchMatchingCities(with: searchText)
        }

        func delete(_ city: City) {
           citiesSelected.removeAll(where: { $0.id == city.id })
        }

        func saveSelectedCities() throws {
            for city in citiesSelected {
                let newLocation = Location(id: city.id, city: city.name, state: city.state, country: city.country, lat: city.coord.lat, lon: city.coord.lon)

                modelContext.insert(newLocation)
                try modelContext.save()
            }
        }
    }
}
