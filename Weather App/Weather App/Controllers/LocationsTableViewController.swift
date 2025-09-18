//
//  LocationsTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class LocationsTableViewController: UITableViewController {

    /**
     First and central screen for the app that shows all the locations that have beeen set for the app
     Weather data is called for each location as a single request for each location and supplied for
     each of the different forecassts within the data structure
     */
    @IBOutlet weak var apiKeyButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!

    var alert: UIAlertController?
    var apiKey = UserDefaults.standard.string(forKey: PropertyKeys.openWeatherAPIKey) {
        didSet {
            willSetBarButtons()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        willSetBarButtons()

        if apiKey == nil {
            // Just for Test Flight Clients as demo
            apiKey = "b138128f7ce2de0582a03cf2c0b69a0b"
            UserDefaults.standard.set(apiKey, forKey: PropertyKeys.openWeatherAPIKey)
//            willCheckForAPIKey()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiKey != nil ? LocationCollection.shared.getLocationsCount() : 0
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

        cell.willSetLocationCell(with: location, at: indexPath.row)

        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                            indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, _) in
            if let location = LocationCollection.shared.getLocationAtIndex(index: indexPath.row) {
                LocationCollection.shared.deleteLocation(location: location)
            }
            tableView.reloadData()
        }
        item.image = UIImage(named: "deleteIcon")

        let swipeActions = UISwipeActionsConfiguration(actions: [item])

        return swipeActions
    }

    // MARK: - Functions
    func willSetBarButtons() {
        /**
         Function to update bar buttons based on state of ViewController
         */
        trashButton.isEnabled = LocationCollection.shared.getLocationsCount() != 0 && apiKey != nil
        apiKeyButton.tintColor = apiKey == nil ? .red : trashButton.tintColor
        addLocationButton.isEnabled = apiKey != nil
    }

    // MARK: - Actions
    @IBAction func clearButtonSelected(_ sender: UIBarButtonItem) {
        LocationCollection.shared.deleteAllLocations()
        trashButton.isEnabled = false
        tableView.reloadData()
    }

    @IBAction func apiKeyButtonSelected(_ sender: UIBarButtonItem) {
        willCheckForAPIKey()
    }

    @IBAction func unwindToLocationsTableview(for unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == PropertyKeys.saveLocationUnwindSegueIdentifier {
            // alphabetical so inserting a single row was more complex and I was lazy
            tableView.reloadData()
            willSetBarButtons()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let destination = segue.destination as? ForecastTableViewController {
            if let locationIndex =  tableView.indexPathForSelectedRow?.row {
                destination.location = LocationCollection.shared.getLocationAtIndex(index: locationIndex)
                destination.navigationItem.title = "\(destination.location.city!), \(destination.location.country!)"
            }
        }
    }

}
