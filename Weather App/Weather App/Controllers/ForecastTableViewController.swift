//
//  ForecastTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class ForecastTableViewController: UITableViewController {

    /**
     Provides choise of forecasts that are supplied by the API
     Weather data is called as a single request and  is aleady expected to be supplied
     prevously.
     Setting of a favourtie removed this screen from the normal sequence of seques
     and transers the user directly to the forecast
     */

    weak var location: Location!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String
        switch indexPath.row {
        case 0:
            identifier = PropertyKeys.currentForecastCellIdentifier
        case 1:
            identifier = PropertyKeys.hourForecastCellIdentifier
        default:
            identifier = PropertyKeys.dayForecastCellIdentifier
        }

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath) as? ForecastTableViewCell
        else {fatalError("Could not dequeue day forecast cell")}

        cell.updateLocationCell(for: indexPath.row)

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

       if let destination = segue.destination as? FavoriteWeattherViewContoller {
           destination.willSetDataForFavourite(with: location, favouriteSeque: false)
       } else {
           fatalError("Forecast View Controller is unreachable from the Locations View Controller")
       }
    }
}
