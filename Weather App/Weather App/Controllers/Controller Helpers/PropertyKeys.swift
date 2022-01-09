//
//  PropertyKeys.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

struct PropertyKeys {
    // central storage of magic keys (strings) refferenced in APP
    // Cell Identifiers
    static let locationCellIdentifier = "locationCellIdentifier"

    static let currentForecastCellIdentifier = "currentForecastCellIdentifier"
    static let hourForecastCellIdentifier = "hourForecastCellIdentifier"
    static let dayForecastCellIdentifier = "dayForecastCellIdentifier"
    static let weeklyweatherCellIdentifier = "weeklyweatherCellIdentifier"

    static let addLocationSearchCellIdentifier = "addLocationSearchCellIdentifier"
    static let addLocationCollectionCellIdentifier = "addLocationCollectionCellIdentifier"
    static let addLocationTableCellIdentifier = "addLocationTableCellIdentifier"

    // Segue Identifiers
    static let addLocationSegueIdentifier = "addLocationSegueIdentifier"
    static let saveLocationUnwindSegueIdentifier = "saveLocationUnwindSegueIdentifier"
    static let chooseForecastSegueIdentifier = "chooseForecastSegueIdentifier"
    static let dayForecastSegueIdentifier = "dayForecastSegueIdentifier"
    static let hourForecastSegueIdentifier = "hourForecastSegueIdentifier"
    static let currentForecastSegueIdentifier = "currentForecastSegueIdentifier"

    // Refresh ID
    static let backgroundRefreshID = "com.xercisepro-weather.refresh"

    // Core Data
    static let locationEntityName = "Locations_CoreData"
    static let previouslyLaunchedKey = "previouslyLaunched"
}
