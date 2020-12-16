//
//  WeekWeatherTableViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 21/9/20.
//

import UIKit

class WeekWeatherTableViewController: UITableViewController {
    
    var location: Location!
    var getWeatherFromAPIDelegate: GetWeatherFromAPIDelegate!
    var weatherResponse: WeatherResponse?
    var favouriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //Update  UI with weather request data but only if required
        getWeatherFromAPIDelegate.weatherRequest(cityLon: location.lon!, cityLat: location.lat!, optionalRequest: true, completion: {
            [weak self] (weather, error) in
            guard let weather = weather else {
                //Error
                DispatchQueue.main.async {
                    if let errorCell = self?.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? WeeklyWeatherTableViewCell{
                        errorCell.updateErrorCell(with: error)
                    }
                    self?.tableView.reloadData()
                }
                return
            }
            DispatchQueue.main.async {
                self?.weatherResponse = weather
                self?.tableView.reloadData()
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherResponse != nil ? 7 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.weeklyweatherCellIdentifier, for: indexPath) as? WeeklyWeatherTableViewCell else{fatalError("Could not dequeue week weather cell")}
        
        guard let weather = weatherResponse else {
            //Error cell returned
            return cell
        }
        
        // Configure the cell...
        cell.updateWeekWeatherCell(with: weather,  index: indexPath.row)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return location.city
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UILabel().font.withSize(24)
        headerView.textLabel?.textAlignment = .center
        headerView.textLabel?.numberOfLines = 0
        headerView.backgroundView?.backgroundColor = .systemGray2
        
        var favouriteButton = UIButton(frame: CGRect(x: tableView.frame.width - 64, y: 5, width: 44, height: 44))
        favouriteButton = Favourite.shared.getFavouriteButtonState(location: location, forecast: .daily, favouriteButton: favouriteButton)
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        self.favouriteButton = favouriteButton
        headerView.contentView.backgroundColor = .systemGray2
        
        headerView.addSubview(favouriteButton)

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.estimatedSectionHeaderHeight + 6.0
    }
    
    //Action for Header Button
    @objc func favouriteButtonTapped(sender: UIButton!) {
        guard  let favouriteButton = self.favouriteButton else {
            return
        }
        self.favouriteButton = Favourite.shared.toggleSetFavouriteButton(location: location, forecast: .daily, favouriteButton: favouriteButton)
     }
}
