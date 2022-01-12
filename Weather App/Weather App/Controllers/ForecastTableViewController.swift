//
//  ForecastTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class ForecastTableViewController: UITableViewController {

    weak var location: Location!
    var performedAutomaticFavouriteSegue = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Process for automated load of favourite
        if performedAutomaticFavouriteSegue {
            switch Favourite.shared.getFavouriteForecast() {
            case .current:
                performSegue(withIdentifier: PropertyKeys.currentForecastSegueIdentifier, sender: self)
            case .hourly:
                performSegue(withIdentifier: PropertyKeys.hourForecastSegueIdentifier, sender: self)
            case .daily:
                performSegue(withIdentifier: PropertyKeys.dayForecastSegueIdentifier, sender: self)
            case .none:
                // swiftlint:disable:next line_length
                fatalError("An unexpected error occured: a favourite should always have a forecast set. This one didn't")
            }
        }
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

        if let destination = segue.destination as? CurrentWeatherViewController {
            destination.location = location
            destination.performedAutomaticFavouriteSegue = performedAutomaticFavouriteSegue
        } else if let destination = segue.destination as? DayWeatherViewController {
            destination.location = location
            destination.performedAutomaticFavouriteSegue = performedAutomaticFavouriteSegue
        } else if let destination = segue.destination as? WeekWeatherTableViewController {
            destination.location = location
            destination.performedAutomaticFavouriteSegue = performedAutomaticFavouriteSegue
        } else {
            fatalError("Forecast View Controller is unreachable from the Locations View Controller")
        }

        performedAutomaticFavouriteSegue = false
    }
}
