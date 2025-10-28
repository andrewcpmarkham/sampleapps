//
//  AddLocationSheet+Extensions.swift
//  Weather App
//
//  Created by Andrew CP Markham on 13/10/2025.
//

import UIKit
import CoreData
import Foundation

extension AddLocationSheet {

    @Observable
    final class ViewModel {

        var locations: [NSManagedObject] = []
        var locationsSelected: [Location] = []

        var title: String { "Add Location" }
        private var lastSearchText = ""
        var searchText: String = "" {
            didSet {
                if searchText != lastSearchText {
                    lastSearchText = searchText
                    loadLocations()
                }
            }
        }

        init() {
            loadLocations()
        }

        func fetchMatchingCities(with searchTerm: String?) -> [NSManagedObject]? {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else {
                    return []
            }
            let dataController = appDelegate.dataControllerDelegate
            return dataController.fetchData(with: searchTerm)
        }

        /// Functions to load locations to from CoreData
        func loadLocations() {
            // Plan is to have the core data preloaded so this is never called
            let searchText: String? = self.searchText.isEmpty ? nil : self.searchText
            if let citiesUnwrapped = fetchMatchingCities(with: searchText) {
                self.locations = citiesUnwrapped
            }
        }

        func delete(_ location: Location) {
            locationsSelected.removeAll(where: { $0.id == location.id })
        }

        func saveSelectedLocations() {
            for location in locationsSelected {
                LocationCollection.shared.addLocation(location: location)
            }
        }
    }
}
