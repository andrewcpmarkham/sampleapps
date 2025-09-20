//
//  WeekWeatherTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class WeekWeatherTableViewController: UITableViewController {
    /**
     Weeks weather forecast suppled by Ooen weather API
     Setting a favorite sets direct transfer to this screen
     */

    weak var location: Location!
    var performedAutomaticFavouriteSegue = false
    var favouriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(false)

        if performedAutomaticFavouriteSegue {
            FavouriteController.shared.willSetWeatherForFavorite(favoriteWeattherable: self)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.weather != nil ? 7 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PropertyKeys.weeklyweatherCellIdentifier,
            for: indexPath) as? WeeklyWeatherTableViewCell
        else {fatalError("Could not dequeue week weather cell")}

        // Favorite will reload on wether data request
        if let weather = location.weather {
            // Configure the cell with weather data
            cell.updateWeekWeatherCell(with: weather, index: indexPath.row)
        } else if !performedAutomaticFavouriteSegue {
            // Error with weather data
            cell.updateErrorCell()
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return location.city
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        guard let headerView = view as? UITableViewHeaderFooterView else {
            print("Error: there was a problem with the UITableViewHeaderFooterView headview section")
            return
        }
        headerView.textLabel?.font = UILabel().font.withSize(24)
        headerView.textLabel?.textColor = .label
        headerView.textLabel?.textAlignment = .center
        headerView.textLabel?.numberOfLines = 0
        headerView.backgroundView?.backgroundColor = .systemGray2

        var favouriteButton = UIButton(frame: CGRect(x: tableView.frame.width - 64, y: 5, width: 44, height: 44))
        favouriteButton = FavouriteController.shared.getFavouriteButtonState(
            location: location, forecast: .daily, favouriteButton: favouriteButton
        )

        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        self.favouriteButton = favouriteButton
        headerView.contentView.backgroundColor = .systemGray2

        headerView.addSubview(favouriteButton)

    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight + 6.0
    }

    // Action for Header Button
    @objc func favouriteButtonTapped(sender: UIButton!) {
        guard  let favouriteButton = self.favouriteButton else {
            return
        }
        self.favouriteButton = FavouriteController.shared.toggleSetFavouriteButton(
            location: location, forecast: .daily, favouriteButton: favouriteButton
        )
     }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        // Transition to favourite on load means Forecast locaation may not be set
        if let destination = segue.destination as? ForecastTableViewController, destination.location == nil {
            destination.location = location
        }
    }
}

extension WeekWeatherTableViewController: FavoriteWeattherViewContoller {
    func willSetDataForFavourite(with location: Location, favouriteSeque: Bool) {
        self.location = location
        self.performedAutomaticFavouriteSegue = favouriteSeque
    }

    func willRefreshUIWithFavoriteLocationData(location: Location) {
        // Single function to perform both tasks for async favorite network call
        self.location = location
        performedAutomaticFavouriteSegue = false
        tableView.reloadData()
    }
}
