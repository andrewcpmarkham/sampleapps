//
//  Favourite.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class Favourite: Codable {
    // Singleton: Idea being that if the app was multi scene this ensures only one favourite
    static var shared =  Favourite()

    private var location: Location?
    private var forecast: Forecast? {
        didSet {
            Favourite.saveToFile(favourite: Favourite.shared).self
        }
    }

    // Default locations for saving of data
    private static let documentsDirectory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let archiveURL =
        documentsDirectory.appendingPathComponent("favourite").appendingPathExtension("plist")

    enum Forecast: String, CodingKey, Codable {

        case current
        case hourly
        case daily

    }

    private enum CodingKeys: String, CodingKey {
        case location
        case forecast
    }

    private init() {
        if let loadedFavourite = Favourite.loadFromFile() {
            self.location = loadedFavourite.location
            self.forecast = loadedFavourite.forecast
        }
    }

    required init(from decoder: Decoder) throws {

        // Decoder for local saved state
        let container = try decoder.container(keyedBy: CodingKeys.self)
        location = try container.decode(Location.self, forKey: .location)
        forecast = try container.decode(Forecast.self, forKey: .forecast)

    }

    // Used on open to perform segue
    func hasFavourite() -> Bool {
        // Function to return true/false of favourite set
        return self.location != nil && self.forecast != nil
    }

    func getFavouriteLocation() -> Location? {
        // Getter function for location property
        guard  let location = self.location else {
            return nil
        }
        return location
    }

    func getFavouriteForecast() -> Forecast? {
        // Getter funtion for forecast property
        guard  let forecast = self.forecast else {
            return nil
        }
        return forecast
    }

    static func saveToFile(favourite: Favourite) {
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
}

extension Favourite {

    func toggleSetFavouriteButton(location: Location, forecast: Forecast, favouriteButton: UIButton) -> UIButton {
        // toggle setter function for style of favourite button
        guard let savedlocation = self.location, let savedForecast = self.forecast else {
            // set it none saved
            self.location = location
            self.forecast = forecast

            favouriteButton.tintColor = .systemYellow

            favouriteButton.animateButton()

            return favouriteButton
        }

        if savedlocation == location && savedForecast == forecast {
            // toggle off
            self.location = nil
            self.forecast = nil
            favouriteButton.tintColor = UIView().tintColor
        } else {
            // toggle on
            self.location = location
            self.forecast = forecast
            favouriteButton.tintColor = .systemYellow
        }

        favouriteButton.animateButton()

        return favouriteButton

    }

    func getFavouriteButtonState(location: Location, forecast: Forecast, favouriteButton: UIButton) -> UIButton {
        // getter function to return favortite button to approprite style
        guard let savedlocation = self.location, let savedForecast = self.forecast else {
            // No favourite set
            favouriteButton.setFavouriteButtonDefaults()
            return favouriteButton
        }
        if savedlocation == location && savedForecast == forecast {
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
