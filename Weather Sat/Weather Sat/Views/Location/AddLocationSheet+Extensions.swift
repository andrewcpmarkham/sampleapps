//
//  AddLocationSheet+Extensions.swift
//  Weather App
//
//  Created by Andrew CP Markham on 13/10/2025.
//

import Foundation
import SwiftData
import SwiftUI

extension AddLocationSheet {

    @Observable
    final class ViewModel {

        private let container: ModelContainer
        private let modelContext: ModelContext

        enum LoadingStatus {
            case loading
            case loaded
            case error
        }

        var loadStatus: LoadingStatus = .loading

        private var cities = [City]()

        // Filtered cities in memory for performance
        var filteredCities: [City] {
            cities.filter {
                searchText.isEmpty ||
                $0.name.localizedStandardContains(searchText)
            }
        }

        var citiesSelected: [City] = []

        var title: String { "Add Location" }
        private var lastSearchText = ""
        var searchText: String = ""

        init(modelContext: ModelContext) {

            self.modelContext = modelContext
            self.container = modelContext.container

            Task {
                await loadCities()
            }
        }

        func loadCities() async {
            let ids: [PersistentIdentifier] = await Task.detached(priority: .userInitiated) { [container] in
                let bgContext = ModelContext(container)
                do {
                    let fetched = try bgContext.fetch(FetchDescriptor<City>())
                    return fetched.map(\.persistentModelID)
                } catch {
                    DispatchQueue.main.async {
                        self.loadStatus = .error
                    }
                    return []
                }
            }.value

            let fetchedOnMain: [City] = ids.compactMap { id in
                (modelContext.model(for: id)) as? City
            }

            loadStatus = .loaded
            withAnimation(.easeInOut) {
                self.cities = fetchedOnMain
            }
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
