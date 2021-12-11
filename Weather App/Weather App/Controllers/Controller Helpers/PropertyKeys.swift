//
//  PropertyKeys.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

struct PropertyKeys {
    //central storage of magic keys (strings) refferenced in APP
    
    static let locationCellIdentifier = "locationCellIdentifier"
    static let weeklyweatherCellIdentifier = "weeklyweatherCellIdentifier"
    static let addLocationCellIdentifier = "addLocationCellIdentifier"
    static let addLocationSegueIdentifier = "addLocationSegueIdentifier"
    static let saveLocationUnwindSegueIdentifier = "saveLocationUnwindSegueIdentifier"
    static let chooseForecastSegueIdentifier = "chooseForecastSegueIdentifier"
    static let dayForecastSegueIdentifier = "dayForecastSegueIdentifier"
    static let hourForecastSegueIdentifier = "hourForecastSegueIdentifier"
    static let currentForecastSegueIdentifier = "currentForecastSegueIdentifier"
    static let backgroundRefreshID = "com.xercisepro-weather.refresh"

    //Core Data
    static let cityEntityID = "cityEntityID"
}
