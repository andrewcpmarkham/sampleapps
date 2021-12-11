//
//  AddLocationTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 30/11/21.
//

import UIKit

class AddLocationTableViewController: UITableViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!

    var locationsSelected: [Int: Location] = [:] {
        didSet {
            saveButton.isEnabled = locationsSelected.isEmpty ? false : true
        }
    }

    var locations: [Location] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadJSONCities()


    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.addLocationCellIdentifier, for: indexPath) as? AddLocationTableViewCell else{fatalError("Could not dequeue location cell")}

        let locationForRow = locations[indexPath.row]
        // Configure the cell...
        cell.updateLocationCell(with: locationForRow, at: indexPath.row)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow( at: indexPath) as? AddLocationTableViewCell else {
            fatalError( "AddLocationTableViewCell cell could not be obtained from the didSelectRowAt method" )
        }
        //Set the selection to storage and show status of selection in row
        let location = locations[indexPath.row]
        guard let id: Int = location.id else {
            return
        }

        locationsSelected[id] = location
        cell.accessoryType = .checkmark
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow( at: indexPath) as? AddLocationTableViewCell else {
            fatalError( "AddLocationTableViewCell cell could not be obtained from the didSelectRowAt method" )
        }
        //Set the selection to storage and show status of selection in row
        let location = locations[indexPath.row]
        guard let id: Int = location.id else {
            return
        }

        locationsSelected.removeValue(forKey: id)
        cell.accessoryType = .none
    }

    // MARK: - Functions
    func fetchMatchingItems() {
        //IMPLEMENT SEARCH ON CITY NAME HERE
    }

    func loadJSONCities(){
        guard let  path = Bundle.main.path(forResource: "city.list", ofType: "json"), let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            return
        }

        guard  let cities = try? JSONDecoder().decode([Location].self, from: json) else {
            return
        }

        locations = cities
    }

    // MARK: - Navigation
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        for (_, location) in locationsSelected {
            LocationCollection.shared.addLocation(location: location)
        }
        performSegue(withIdentifier: PropertyKeys.saveLocationUnwindSegueIdentifier, sender: self)
    }

}
