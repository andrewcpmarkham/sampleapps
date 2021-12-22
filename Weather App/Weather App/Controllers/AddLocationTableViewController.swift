//
//  AddLocationTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 30/11/21.
//

import UIKit
import CoreData

class AddLocationTableViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!

    var locationsSelected: [Int: NSManagedObject] = [:] {
        didSet {
            saveButton.isEnabled = locationsSelected.isEmpty ? false : true
        }
    }

    var locations: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLocations()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return locations.count
        default:
            return 1
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // SearchBar
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PropertyKeys.addLocationSearchCellIdentifier,
                    for: indexPath) as? AddLocationSearchTableViewCell  else {
                        fatalError("Could not dequeue location search cell")
                    }
            cell.updateQuickSearchBar(addLocationTableViewController: self)
            return cell

        case 1:
            // Location Cell
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PropertyKeys.addLocationCellIdentifier,
                    for: indexPath) as? AddLocationTableViewCell else {
                        fatalError("Could not dequeue location cell")
                    }
            let locationForRow = locations[indexPath.row]
            // Configure the cell...
            cell.updateLocationCell(with: locationForRow, at: indexPath.row)
            return cell

        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow( at: indexPath) as? AddLocationTableViewCell else {
            fatalError( "AddLocationTableViewCell cell could not be obtained from the didSelectRowAt method" )
        }
        // Set the selection to storage and show status of selection in row
        let location = locations[indexPath.row]
        // swiftlint:disable:next identifier_name
        guard let id = location.value(forKey: "id") as? Int else {
            return
        }

        locationsSelected[id] = location
        cell.accessoryType = .checkmark
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow( at: indexPath) as? AddLocationTableViewCell else {
            fatalError( "AddLocationTableViewCell cell could not be obtained from the didSelectRowAt method" )
        }
        // Set the selection to storage and show status of selection in row
        let location = locations[indexPath.row]
        // swiftlint:disable:next identifier_name
        guard let id = location.value(forKey: "id") as? Int else {
            return
        }

        locationsSelected.removeValue(forKey: id)
        cell.accessoryType = .none
    }

    // MARK: - Functions
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

    // MARK: - Navigation
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        for (_, location) in locationsSelected {
            // Convert from coredata object to location object
            if
                // swiftlint:disable:next identifier_name
                let id = location.value(forKey: "id") as? Int,
                let city = location.value(forKey: "city") as? String,
                let state = location.value(forKey: "state") as? String,
                let country = location.value(forKey: "country") as? String,
                let lat = location.value(forKey: "lat") as? Double,
                let lon = location.value(forKey: "lon") as? Double
            {
                let newLocation = Location(id: id, city: city, state: state, country: country, lat: lat, lon: lon)
                LocationCollection.shared.addLocation(location: newLocation)
            } else {
                print("Error: there was a problem converting/adding the selected location to the LocationCollection")
            }
        }
        performSegue(withIdentifier: PropertyKeys.saveLocationUnwindSegueIdentifier, sender: self)
    }

}

// MARK: - Protocols
/// Implementation of  functionality for search bar
/// to enact search and clear search
extension AddLocationTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Function for action of search triggered
        if let cities = fetchMatchingCities(with: searchBar.text) {
            self.locations = cities
        } else {
            self.locations = []
        }
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    // Acton for when the clear button in the search bar is clicked
    @objc func searchBarXButtonClicked() {
        if let cities = fetchMatchingCities(with: nil) {
            self.locations = cities
        } else {
            self.locations = []
        }
        tableView.reloadSections([1], with: .automatic)
    }
}
