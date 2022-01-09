//
//  AddLocationViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 23/12/21.
//

import UIKit
import CoreData

class AddLocationViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectedLocationsLabel: UILabel!
    @IBOutlet weak var selectedLocationsCollectionView: UICollectionView!
    @IBOutlet weak var locationsTableView: UITableView!

    var locationsSelected: [Int: NSManagedObject] = [:] {
        didSet {
            saveButton.isEnabled = locationsSelected.isEmpty ? false : true
            selectedLocationsLabel.isEnabled = locationsSelected.isEmpty ? false : true
            selectedLocationsCollectionView.reloadData()
            selectedLocationsLabel.text = locationsSelected.isEmpty ? "Locations Selected" :
                "Locations Selected - \(locationsSelected.count)"
        }
    }

    var locations: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedLocationsCollectionView.delegate = self
        selectedLocationsCollectionView.dataSource = self
        locationsTableView.delegate = self
        locationsTableView.dataSource = self

        willSetupSearchBar()
        willSetUpTableView()
        loadLocations()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Update Locations if selected
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
    }
}

// MARK: CollectionView
extension AddLocationViewController: UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationsSelected.count
    }

    // swiftlint:disable:next line_length
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Location Selected Cells
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PropertyKeys.addLocationCollectionCellIdentifier,
            for: indexPath) as? AddLocationCollectionViewCell else {
            fatalError("Could not dequeue location collection cell")
        }

        // Configure the cell...
        let locationSelectedKeys = Array(locationsSelected.keys)
        let keyforCell = locationSelectedKeys[indexPath.row]
        if let locationForRow = locationsSelected[keyforCell] {
            cell.updateLocationCell(with: locationForRow, at: indexPath.row)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath ) as? AddLocationCollectionViewCell {
            locationsSelected.removeValue(forKey: cell.locationID)
            locationsTableView.reloadData()
        }
    }
}

// MARK: TableView
extension AddLocationViewController: UITableViewDataSource, UITableViewDelegate {

    func willSetUpTableView () {
        locationsTableView.rowHeight = UITableView.automaticDimension
        locationsTableView.estimatedRowHeight = 68
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Location Cell
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PropertyKeys.addLocationTableCellIdentifier,
                for: indexPath) as? AddLocationTableViewCell else {
                    fatalError("Could not dequeue location table cell")
                }
        let locationForRow = locations[indexPath.row]
        // Configure the cell...
        cell.updateLocationCell(with: locationForRow, at: indexPath.row)
        if let locationID = locationForRow.value(forKey: "id") as? Int, locationsSelected.keys.contains(locationID) {
            cell.setSelected(true, animated: true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
        cell.setSelected(true, animated: true)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
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
        cell.setSelected(false, animated: true)
    }
}

// MARK: - SearchBar
/// Implementation of  functionality for search bar
/// to enact search and clear search
extension AddLocationViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let cities = fetchMatchingCities(with: searchBar.text) {
            self.locations = cities
        } else if searchText == "", let cities = fetchMatchingCities(with: nil) {
            self.locations = cities
        } else {
            self.locations = []
        }
        locationsTableView.reloadData()
    }
    func willSetupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search City..."

        // Hijack the clear 'X' of the search bar
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField,
           let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            clearButton.addTarget(
                self,
                action: #selector(self.searchBarXButtonClicked),
                for: .touchUpInside
            )
        }
    }

    // Acton for when the clear button in the search bar is clicked
    @objc func searchBarXButtonClicked() {
        if let cities = fetchMatchingCities(with: nil) {
            self.locations = cities
        } else {
            print("Error with func searchBarXButtonClicked as the 'x' button should show all cities")
        }
        locationsTableView.reloadData()
    }
}
