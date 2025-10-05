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
        var apiKeyButtonEnabled: Bool
        var addLocationButtonEnabled: Bool
        var filteredLocations: [Location] {
            // TODO: - Complete list here please
            []
        }

        var modalState: ModalState = .none

        private var lastSearchText: String = ""
        var searchText: String = "" {
            didSet {
                // Avoid fetching if search text is unchanged
                if searchText != lastSearchText {
                    lastSearchText = searchText
                    loadData()
                }
            }
        }

        init() {
            trashButtonEnabled = LocationCollection.shared.getLocationsCount() > 0
            apiKeyButtonEnabled = true // Need to get this from keychain
            addLocationButtonEnabled = true // = apiKey != nil
        }

        func loadData() {
//            do {
//                let sortDescriptor = [
//                    SortDescriptor(\Contact.favorite_,  order: .reverse), SortDescriptor(\Contact.nameFirst_)
//                ]
//                if searchText.isEmpty {
//                    let descriptor = FetchDescriptor<Contact>(sortBy: sortDescriptor)
//                    contacts = try modelContext.fetch(descriptor)
//                } else {
//                    let contactPredicate = #Predicate<Contact> { contact in
//                        contact.nameFirst_.localizedStandardContains(searchText) || contact.nameLast_.localizedStandardContains(searchText)
//                    }
//
//                    let descriptor = FetchDescriptor<Contact>(predicate: contactPredicate, sortBy: sortDescriptor)
//                    contacts = try modelContext.fetch(descriptor)
//                }
//            } catch {
//                print("Fetch failed")
//            }
        }

        func clearButtonSelected() {
            LocationCollection.shared.deleteAllLocations()
            trashButtonEnabled = false
        }

        func apiKeyButtonSelected() {
            modalState = .showAPIKeyAlert
        }
    }
}
