//
//  dayWeatherViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class DayWeatherViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDetailLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    weak var location: Location!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup animation to indicate network activity
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()

        // Update UI with known data
        updateUI()

        // Update UI with data if available
        if location.weather != nil {
            updateUIWithWeatherFromAPI()
        } else {
            networkErrorNotification()
        }
    }

    func updateUIWithWeatherFromAPI() {
        // Function to update View based on data retruned back from API
        // Get Icon, then load interface

        if
            let weather = location.weather,
            let todaysWeather = location.weather?.dailyWeather[1],
            let icon = todaysWeather.weather.first?.icon,
            let iconURL = GetWeatherFromAPIDelegate.getIconURL(with: icon) {
            // Set known Data
            dateLabel.text = Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: todaysWeather.dt + weather.timezoneOffset)
            )
            dateLabel.textColor = windDirectionLabel.textColor // ensures default colour is applied
            weatherDetailLabel.text = todaysWeather.weather.first?.detail
            maxTemperatureLabel.text = "High: " + String(format: "%.0f", todaysWeather.tempMax) + "C"
            minTemperatureLabel.text = "Low: " + String(format: "%.0f", todaysWeather.tempMin) + "C"
            windDirectionLabel.text = "Wind Direction: \(weather.windDirection)º"
            windSpeedLabel.text = "Wind Speed: " + String(format: "%.1f", weather.windSpeed) + "km/h"
            // get weather icon
            let task = URLSession.shared.dataTask(with: iconURL, completionHandler: { [weak self](data, _, _ ) in
                // get weather icon
                guard let data = data, let image = UIImage(data: data) else {return}
                DispatchQueue.main.async {
                    self?.weatherImage.image = image
                    self?.activityIndicator.stopAnimating()
                }
            })
            task.resume()
        }
    }

    func updateUI() {
        // Function to update UI based on data stored within app (not network requested)
        locationLabel.text = location.city
        favouriteButton = Favourite.shared.getFavouriteButtonState(
            location: location, forecast: .hourly, favouriteButton: favouriteButton
        )
    }

    func networkErrorNotification() {
        // Function to update UI based on netork error
        self.weatherImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
        self.weatherImage.tintColor = .red
        self.weatherDetailLabel.text = ""
        self.dateLabel.text = "Error"
        self.dateLabel.textColor = .red
        self.maxTemperatureLabel.text = ""
        self.minTemperatureLabel.text = ""
        // swiftlint:disable:next line_length
        self.windDirectionLabel.text = "Current Weather can't be optained, please check network connection and try again."
    }

    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        favouriteButton = Favourite.shared.toggleSetFavouriteButton(
            location: location, forecast: .hourly, favouriteButton: favouriteButton
        )
    }
}
