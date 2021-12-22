//
//  WeekWeatherTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class WeekWeatherTableViewController: UITableViewController {

    weak var location: Location!
    var favouriteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(false)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.weather != nil ? 7 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PropertyKeys.weeklyweatherCellIdentifier,
            for: indexPath) as? WeeklyWeatherTableViewCell
        else {fatalError("Could not dequeue week weather cell")}

        guard let weather = location.weather else {
            // Error cell returned
            cell.updateErrorCell()
            return cell
        }

        // Configure the cell...
        cell.updateWeekWeatherCell(with: weather, index: indexPath.row)

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
        headerView.textLabel?.textAlignment = .center
        headerView.textLabel?.numberOfLines = 0
        headerView.backgroundView?.backgroundColor = .systemGray2

        var favouriteButton = UIButton(frame: CGRect(x: tableView.frame.width - 64, y: 5, width: 44, height: 44))
        favouriteButton = Favourite.shared.getFavouriteButtonState(
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
        self.favouriteButton = Favourite.shared.toggleSetFavouriteButton(
            location: location, forecast: .daily, favouriteButton: favouriteButton
        )
     }
}
