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
        
        
        //Process for automated load of favourite
        if performedAutomaticFavouriteSegue {
            
            performedAutomaticFavouriteSegue = false
            
            switch Favourite.shared.getFavouriteForecast() {
            case .current:
                performSegue(withIdentifier: PropertyKeys.currentForecastSegueIdentifier, sender: self)
            case .hourly:
                performSegue(withIdentifier: PropertyKeys.hourForecastSegueIdentifier, sender: self)
            case .daily:
                performSegue(withIdentifier: PropertyKeys.dayForecastSegueIdentifier, sender: self)
            case .none:
                fatalError("An unexpected error occured: a favourite should always have a forecast set. This one didn't")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let destination = segue.destination as? CurrentWeatherViewController{
            destination.location = location
            
        }else if let destination = segue.destination as? DayWeatherViewController{
            destination.location = location
        }else if let destination = segue.destination as? WeekWeatherTableViewController{
            destination.location = location
        } else {
            fatalError("Forecast View Controller is unreachable from the Locations View Controller")
        }
    }
}
