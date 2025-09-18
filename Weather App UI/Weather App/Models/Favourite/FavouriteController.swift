//
//  Favourite.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

protocol FavoriteWeattherViewContoller: UIViewController {
    func willRefreshUIWithFavoriteLocationData (location: Location)
    func willSetDataForFavourite (with location: Location, favouriteSeque: Bool)
}

class FavouriteController {

    static var shared =  FavouriteController()

    // Default locations for saving of data
    private static let documentsDirectory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archiveURL =
        documentsDirectory.appendingPathComponent("favourite").appendingPathExtension("plist")

    private init() {}
    // Used on open to perform segue
    func willSetWeatherForFavorite(favoriteWeattherable: FavoriteWeattherViewContoller) {
        guard let favourite = FavouriteController.loadFromFile() else {return}
        let location = favourite.location
        location.getWeatherFromAPIDelegate.weatherRequest(
            cityLon: location.lon, cityLat: location.lat, optionalRequest: false,
            completion: {(weather, error) in
                guard let weather = weather else {
                    DispatchQueue.main.async {
                        print("Error: \(error.debugDescription)")
                    }
                    favoriteWeattherable.willRefreshUIWithFavoriteLocationData(location: location)
                    return
                }

                DispatchQueue.main.async {
                    location.weather = weather
                    FavouriteController.shared.settFavouriteLocation( location: location )
                    favoriteWeattherable.willRefreshUIWithFavoriteLocationData(location: location)
                }
            })
    }

    func hasFavourite() -> Bool {
        guard let _ = FavouriteController.loadFromFile() else {return false}
        // Function to return true/false of favourite set
        return true
    }

    func settFavouriteLocation(location: Location) {
        guard let favourite = FavouriteController.loadFromFile() else {return}
        FavouriteController.saveToFile(favourite: Favourite(location: location, forecast: favourite.forecast))
    }

    func getFavouriteLocation() -> Location? {
        guard let favourite = FavouriteController.loadFromFile() else {return nil}
        return favourite.location
    }

    func getFavouriteForecast() -> Favourite.Forecast? {
        guard let favourite = FavouriteController.loadFromFile() else {return nil}
        return favourite.forecast
    }

    static func saveToFile(favourite: Favourite?) {
        guard let favourite = favourite else {
            // clear saved
            try? FileManager.default.removeItem(at: archiveURL)
            return
        }
        // Function to save data to file
        let propertyListEncoder = PropertyListEncoder()
        let encodedEmoji = try? propertyListEncoder.encode(favourite)

        try? encodedEmoji?.write(to: archiveURL, options: .noFileProtection)
    }

    static func loadFromFile() -> Favourite? {
        // Function to load data to file
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedLocationData = try? Data(
            contentsOf: archiveURL),
            let decodedFavourite = try? propertyListDecoder.decode(Favourite.self, from: retrievedLocationData) {
            return decodedFavourite
        }
        return nil
    }

    func toggleSetFavouriteButton(location: Location, forecast: Favourite.Forecast, favouriteButton: UIButton) -> UIButton {
        let favourite = Favourite(location: location, forecast: forecast)
        // toggle setter function for style of favourite button
        guard
            let savedFavourite = FavouriteController.loadFromFile()
        else {
            // set it none saved
            FavouriteController.saveToFile(favourite: favourite)

            favouriteButton.tintColor = .systemYellow

            favouriteButton.animateButton()

            return favouriteButton
        }

        if favourite == savedFavourite {
            FavouriteController.saveToFile(favourite: nil)
            favouriteButton.tintColor = UIView().tintColor
        } else {
            // toggle on
            FavouriteController.saveToFile(favourite: favourite)
            favouriteButton.tintColor = .systemYellow
        }

        favouriteButton.animateButton()

        return favouriteButton

    }

    //DEPRECATED
    func getFavouriteButtonState(location: Location, forecast: Favourite.Forecast, favouriteButton: UIButton) -> UIButton {
        // getter function to return favortite button to approprite style
        guard
            let savedFavourite = FavouriteController.loadFromFile()
        else {
            // No favourite set
            favouriteButton.setFavouriteButtonDefaults()
            return favouriteButton
        }
        if savedFavourite.location == location && savedFavourite.forecast == forecast {
            // Is the favourite
            favouriteButton.setFavouriteButtonDefaults()
            favouriteButton.tintColor = .systemYellow
            return favouriteButton
        } else {
            // Not the favourite
            favouriteButton.setFavouriteButtonDefaults()
            return favouriteButton
        }
    }
}

extension UIButton {

    func setFavouriteButtonDefaults() {
        // Default style for favourite button
        let favouriteSymbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let favouriteImage = UIImage(systemName: "star", withConfiguration: favouriteSymbolConfiguration)
        self.setImage(favouriteImage, for: .normal)
    }

    func animateButton() {
        // Animation for button icons
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            },
            completion: {(_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.imageView?.transform = CGAffineTransform.identity
                    })
            }
        )
    }
}
