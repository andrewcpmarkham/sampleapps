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

        var title: String { "Weather Locations" }
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
            if let citiesUnwrapped = fetchMatchingCities(with: nil) {
                self.locations = citiesUnwrapped
            }
        }
    }
}
