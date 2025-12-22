//
//  LocationsView+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 28/9/2025.
//

import Foundation
import SwiftData

extension LocationsView {

    // Combined with Global Login state
    enum ModalState: Equatable {
        case none
        case showAddLocationSheet
        case showAPIKeyAlert
        case showDeleteAlert
        case showErrorAlert(String)

        var errorMessage: String? {
            if case let .showErrorAlert(message) = self {
                return message
            }
            return nil
        }

        static func == (lhs: ModalState, rhs: ModalState) -> Bool {
                switch (lhs, rhs) {
                case (.none, .none):
                    return true
                case (.showAddLocationSheet, .showAddLocationSheet):
                    return true
                case (.showAPIKeyAlert, .showAPIKeyAlert):
                    return true
                case(.showDeleteAlert, .showDeleteAlert):
                    return true
                case (.showErrorAlert(_), .showErrorAlert(_)):
                    return true
                default:
                    return false
                }
            }
    }

    @Observable
    final class ViewModel {

        var title: String { "Weather Locations"}
        var trashButtonEnabled: Bool {
            !filteredLocations.isEmpty
        }
        var apiKeyStored = false
        var addLocationButtonEnabled = false
        var filteredLocations: [Location] = []

        var didSeedDefaults: Bool = true {
            didSet {
                AppSettingsManager.shared.set(didSeedDefaults, for: .didSeedDefaults)
            }
        }
        let modelContext: ModelContext

        var modalState: ModalState = .none

        private var lastSearchText: String = ""
        var searchText: String = "" {
            didSet {
                if searchText != lastSearchText {
                    lastSearchText = searchText
                    loadData()
                }
            }
        }

        // MARK: - Init

        init(modelContext: ModelContext) {
            self.modelContext = modelContext

            // Set properties from local storage
            Task {
                didSeedDefaults = AppSettingsManager.shared.bool(for: .didSeedDefaults)
                await updateToolBarButtonStates()
                if apiKeyStored {
                    loadData()
                } else {
                    modalState = .showAPIKeyAlert
                }
            }
        }

        // MARK: - Private Functions

        private func loadDefaultLocations() {
            modelContext.insert(Location(id: 2147714, city: "Sydney", state: "NSW", country: "AU", lat: -33.87, lon: 151.21))
            modelContext.insert(Location(id: 2158177, city: "Melbourne", state: "VIC", country: "AU", lat: -37.81, lon: 144.96))
            modelContext.insert(Location(id: 2174003, city: "Brisbane", state: "QLD", country: "AU", lat: -27.47, lon: 153.03))
        }

        // MARK: - Functions

        func loadData() {

            if !didSeedDefaults {
                loadDefaultLocations()
                didSeedDefaults = true
            }

            do {
                let sortDescriptor = [ SortDescriptor(\Location.city, order: .forward)]
                if searchText.isEmpty {
                    let descriptor = FetchDescriptor<Location>(sortBy: sortDescriptor)
                    filteredLocations = try modelContext.fetch(descriptor)
                } else {
                    let locationPredicate = #Predicate<Location> { location in
                        location.city.localizedStandardContains(searchText)
                    }

                    let descriptor = FetchDescriptor<Location>(predicate: locationPredicate, sortBy: sortDescriptor)
                    filteredLocations = try modelContext.fetch(descriptor)
                }
            } catch {
                print("Fetch failed")
            }
        }

        func delete(_ location: Location) {
            modelContext.delete(location)
            try? modelContext.save()
            loadData()
        }

        func deleteAllButtonSelected() {
            do {
                let descriptor = FetchDescriptor<Location>()
                let locations = try modelContext.fetch(descriptor)

                for location in locations {
                    modelContext.delete(location)
                    try modelContext.save()
                }
            } catch {
                modalState = .showErrorAlert("There was an error deleting the locations. Please try again.")
            }
        }

        func apiKeyButtonSelected() {
            modalState = .showAPIKeyAlert
        }

        func updateToolBarButtonStates() async {
            let hasKey = (try? await KeychainManager.shared.getAPIKey()) != nil
            self.apiKeyStored = hasKey
            self.addLocationButtonEnabled = hasKey
        }
    }
}
