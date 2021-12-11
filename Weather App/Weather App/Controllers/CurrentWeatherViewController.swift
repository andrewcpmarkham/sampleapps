//
//  currentWeatherViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class CurrentWeatherViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDetailLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    weak var location: Location!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(false)
        
        //Update UI with known data
        updateUI()

        //Update UI with data if available
        if let _ = location.weather {
            updateUIWithWeatherFromAPI()
        } else {
            networkErrorNotification()
        }
    }

    func updateUI() {
        //Function to update UI based on data stored within app (not network requested)
        locationLabel.text = location.city
        favouriteButton = Favourite.shared.getFavouriteButtonState(location: location, forecast: .current, favouriteButton: favouriteButton)
    }
    
    func updateUIWithWeatherFromAPI() {
        //Function to update View based on data retruned back from API
        if let weather = location.weather, let currentWeather = weather.weather.first, let iconURL = GetWeatherFromAPIDelegate.getIconURL(with: currentWeather.icon){

            //Set known Data
            weatherDetailLabel.text = "\(currentWeather.detail)"
            temperatureLabel.text = String(format: "%.0f", weather.temp) + "C"
            temperatureLabel.textColor = windDirectionLabel.textColor//ensures default colour is applied
            windDirectionLabel.text = "Wind Direction: \(weather.windDirection)º"
            windSpeedLabel.text = "Wind Speed: " + String(format: "%.1f", weather.windSpeed) + "km/h"

            //get weather icon
            let task = URLSession.shared.dataTask(with: iconURL, completionHandler: { [weak self](data, response, error ) in
                
                guard let data = data, let image = UIImage(data: data) else {return}
                DispatchQueue.main.async {
                    self?.weatherImage.image = image
                }
            })
            task.resume()
        }
    }
    

    
    func networkErrorNotification(){
        //Function to update UI based on netork error
        self.weatherImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
        self.weatherImage.tintColor = .red
        self.weatherDetailLabel.text = ""
        self.temperatureLabel.text = "Error"
        self.temperatureLabel.textColor = .red
        self.windDirectionLabel.text = "Current Weather can't be optained, please check network connection and try again."

    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        favouriteButton = Favourite.shared.toggleSetFavouriteButton(location: location, forecast: .current, favouriteButton: favouriteButton)
    }
    
    
    
}
