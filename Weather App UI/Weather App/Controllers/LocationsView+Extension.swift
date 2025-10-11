//
//  LocationsView+Extension.swift
//  Weather App
//
//  Created by Andrew CP Markham on 28/9/2025.
//

import Foundation

extension LocationsView {

    // Combined with Global Login state
    enum ModalState: Equatable {
        case none
        case showAPIKeyAlert
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
                case (.showAPIKeyAlert, .showAPIKeyAlert):
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
        var trashButtonEnabled: Bool
        var apiKeyButtonEnabled: Bool = false
        var addLocationButtonEnabled: Bool
        var filteredLocations: [Location] = []

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

        init() {
            trashButtonEnabled = LocationCollection.shared.getLocationsCount() > 0
            addLocationButtonEnabled = true
            apiKeyButtonEnabled = false

            loadData()
            updateToolBarButtonStates()
        }

        func loadData() {
            let locationsStored = LocationCollection.shared.getAllLocations()

            if searchText.isEmpty || locationsStored.isEmpty {
                filteredLocations = LocationCollection.shared.getAllLocations().sorted()
                return
            }
            filteredLocations = locationsStored.filter {
                $0.city.lowercased().contains(searchText.lowercased())
            }.sorted()
        }

        func delete(_ location: Location) {
            LocationCollection.shared.deleteLocation(location: location)
            loadData()
        }

        func clearButtonSelected() {
            LocationCollection.shared.deleteAllLocations()
            trashButtonEnabled = false
        }

        func apiKeyButtonSelected() {
            modalState = .showAPIKeyAlert
        }

        func updateToolBarButtonStates() {
            Task {
                let hasKey = (try? await KeychainManager.shared.getAPIKey()) != nil
                self.apiKeyButtonEnabled = hasKey
                self.addLocationButtonEnabled = hasKey
            }
        }
    }
}
