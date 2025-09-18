//
//  currentWeatherViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    /**
     Current weather forecast suppled by Ooen weather API
     Setting a favorite sets direct transfer to this screen
     */

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDetailLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var location: Location!
    var performedAutomaticFavouriteSegue = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup animation to indicate network activity
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        // Update UI with known data
        updateUI()
        // Update UI with data if available
        if performedAutomaticFavouriteSegue {
            FavouriteController.shared.willSetWeatherForFavorite(favoriteWeattherable: self)
        } else if location.weather != nil {
            updateUIWithWeatherFromAPI()
        } else {
            networkErrorNotification()
        }
    }

    func updateUI() {
        // Function to update UI based on data stored within app (not network requested)
        locationLabel.text = location.city
        favouriteButton = FavouriteController.shared.getFavouriteButtonState(
            location: location,
            forecast: .current,
            favouriteButton: favouriteButton
        )
    }

    func updateUIWithWeatherFromAPI() {
        // Function to update View based on data retruned back from API
        if
            let weather = location.weather,
            let currentWeather = weather.weather.first,
            let iconURL = GetWeatherFromAPIDelegate.getIconURL(with: currentWeather.icon) {

                // Set known Data
                weatherDetailLabel.text = "\(currentWeather.detail)"
                temperatureLabel.text = String(format: "%.0f", weather.temp) + "C"
                temperatureLabel.textColor = windDirectionLabel.textColor // ensures default colour is applied
                windDirectionLabel.text = "Wind Direction: \(weather.windDirection)º"
                windSpeedLabel.text = "Wind Speed: " + String(format: "%.1f", weather.windSpeed) + "km/h"

                // get weather icon
                let task = URLSession.shared.dataTask(
                    with: iconURL, completionHandler: { [weak self](data, _, _ ) in
                        guard let data = data, let image = UIImage(data: data) else {return}
                        DispatchQueue.main.async {
                            self?.weatherImage.image = image
                            self?.activityIndicator.stopAnimating()
                        }
                })
                task.resume()
        }
    }

    func networkErrorNotification() {
        // Function to update UI based on netork error
        self.weatherImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
        self.weatherImage.tintColor = .red
        self.weatherDetailLabel.text = ""
        self.temperatureLabel.text = "Error"
        self.temperatureLabel.textColor = .red
        // swiftlint:disable:next line_length
        self.windDirectionLabel.text = "Current Weather can't be optained, please check network connection and try again."
    }

    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        favouriteButton = FavouriteController.shared.toggleSetFavouriteButton(
            location: location,
            forecast: .current,
            favouriteButton: favouriteButton
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

extension CurrentWeatherViewController: FavoriteWeattherViewContoller {
    func willSetDataForFavourite(with location: Location, favouriteSeque: Bool) {
        self.location = location
        self.performedAutomaticFavouriteSegue = favouriteSeque
    }

    func willRefreshUIWithFavoriteLocationData(location: Location) {
        // Single function to perform both tasks for async favorite network call
        self.location = location
        if location.weather != nil {
            updateUIWithWeatherFromAPI()
        } else {
            networkErrorNotification()
        }
        activityIndicator.stopAnimating()
        performedAutomaticFavouriteSegue = false
    }
}
