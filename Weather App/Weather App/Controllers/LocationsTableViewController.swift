//
//  LocationsTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class LocationsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if favourite is set
        if Favourite.shared.hasFavourite() {
            performSegue(withIdentifier: PropertyKeys.chooseForecastSegueIdentifier, sender: self)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationCollection.shared.getLocationsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PropertyKeys.locationCellIdentifier,
            for: indexPath) as? LocationsTableViewCell
        else {fatalError("Could not dequeue location cell")}

        // Configure the cell...
        guard let location = LocationCollection.shared.getLocationAtIndex(index: indexPath.row) else {
            return  cell
        }

        cell.updateLocationCell(with: location, at: indexPath.row)

        return cell
    }

    // MARK: - Actions
    @IBAction func clearButtonSelected(_ sender: UIBarButtonItem) {
        LocationCollection.shared.deleteAllLocations()
        tableView.reloadData()
    }

    @IBAction func unwindToLocationsTableview(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == PropertyKeys.saveLocationUnwindSegueIdentifier {
            // alphabetical so inserting a single row was more complex and I was lazy
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let destination = segue.destination as? ForecastTableViewController {
            if let locationIndex =  tableView.indexPathForSelectedRow?.row {
                destination.location = LocationCollection.shared.getLocationAtIndex(index: locationIndex)
                destination.navigationItem.title = "\(destination.location.city!), \(destination.location.country!)"
            } else if let favouriteLocation = Favourite.shared.getFavouriteLocation() {
                destination.location = favouriteLocation
                destination.navigationItem.title = "\(favouriteLocation.city!), \(favouriteLocation.country!)"
                destination.performedAutomaticFavouriteSegue = true
            }
        }
    }

}
