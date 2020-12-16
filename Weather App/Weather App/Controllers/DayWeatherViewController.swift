//
//  dayWeatherViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/20.
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
    
    var location: Location!
    var getWeatherFromAPIDelegate: GetWeatherFromAPIDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update UI with known data
        updateUI()
        
        //Update  UI with weather request data but only if required
        getWeatherFromAPIDelegate.weatherRequest(cityLon: location.lon!, cityLat: location.lat!, optionalRequest: true, completion: {
            [weak self] (weather, error) in
            guard let weather = weather else {
                //Error
                DispatchQueue.main.async {
                    self?.networkErrorNotification(error: error)
                }
                return
            }
            DispatchQueue.main.async {
                self?.updateUIWithWeatherFromAPI(with: weather)
            }
        })
    }

    func updateUIWithWeatherFromAPI(with weather: WeatherResponse) {
        //Function to update View based on data retruned back from API
        //Get Icon, then load interface
        let todaysWeather = weather.dailyWeather[1]
        if let icon = todaysWeather.weather.first?.icon, let iconURL = GetWeatherFromAPIDelegate.getIconURL(with: icon){
            //get weather icon
            let task = URLSession.shared.dataTask(with: iconURL, completionHandler: { [weak self](data, response, error ) in
                
                guard let data = data, let image = UIImage(data: data) else {return}
                DispatchQueue.main.async {
                    self?.weatherImage.image = image
                    self?.dateLabel.text = Date.dateOnlyFormatter.string(from: Date.dateFromUTCInt(UTCTimeStamp: todaysWeather.dt + weather.timezoneOffset))
                    self?.dateLabel.textColor = self?.windDirectionLabel.textColor //ensures default colour is applied
                    self?.weatherDetailLabel.text = todaysWeather.weather.first?.detail
                    self?.maxTemperatureLabel.text = "High: " + String(format: "%.0f", todaysWeather.tempMax) + "C"
                    self?.minTemperatureLabel.text = "Low: " + String(format: "%.0f", todaysWeather.tempMin) + "C"
                    self?.windDirectionLabel.text = "Wind Direction: \(weather.windDirection)º"
                    self?.windSpeedLabel.text = "Wind Speed: " + String(format: "%.1f", weather.windSpeed) + "km/h"
                }
            })
            task.resume()
        }
    }
    
    func updateUI() {
        //Function to update UI based on data stored within app (not network requested)
        locationLabel.text = location.city
        favouriteButton = Favourite.shared.getFavouriteButtonState(location: location, forecast: .hourly, favouriteButton: favouriteButton)
    }
    
    func networkErrorNotification(error: Error?){
        //Function to update UI based on netork error
        self.weatherImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
        self.weatherImage.tintColor = .red
        self.weatherDetailLabel.text = ""
        self.dateLabel.text = "Error"
        self.dateLabel.textColor = .red
        self.maxTemperatureLabel.text = ""
        self.minTemperatureLabel.text = ""
        self.windDirectionLabel.text = "Current Weather can't be optained, please check network connection and try again."
        if let error = error{
            self.windSpeedLabel.text = "Error: \(error.localizedDescription)"
        }
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        favouriteButton = Favourite.shared.toggleSetFavouriteButton(location: location, forecast: .hourly, favouriteButton: favouriteButton)
    }
    
}
