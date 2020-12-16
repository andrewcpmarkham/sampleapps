//
//  currentWeatherViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/20.
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
    
    var location: Location!
    var getWeatherFromAPIDelegate: GetWeatherFromAPIDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(false)
        
        //Update UI with known data
        updateUI()
        
        //Update  UI with weather request data and always perform as it is current weather
        getWeatherFromAPIDelegate.weatherRequest(cityLon: location.lon!, cityLat: location.lat!, optionalRequest: false, completion: {
            [weak self] (weather, error) in
            guard let weather = weather else {
                DispatchQueue.main.async {
                    //Error
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
        //Get Icon
        if let currentWeather = weather.weather.first, let iconURL = GetWeatherFromAPIDelegate.getIconURL(with: currentWeather.icon){
            //get weather icon
            let task = URLSession.shared.dataTask(with: iconURL, completionHandler: { [weak self](data, response, error ) in
                
                guard let data = data, let image = UIImage(data: data) else {return}
                DispatchQueue.main.async {
                    self?.weatherImage.image = image
                    self?.weatherDetailLabel.text = "\(currentWeather.detail)"
                    self?.temperatureLabel.text = String(format: "%.0f", weather.temp) + "C"
                    self?.temperatureLabel.textColor = self?.windDirectionLabel.textColor//ensures default colour is applied
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
        favouriteButton = Favourite.shared.getFavouriteButtonState(location: location, forecast: .current, favouriteButton: favouriteButton)
    }
    
    func networkErrorNotification(error: Error?){
        //Function to update UI based on netork error
        self.weatherImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
        self.weatherImage.tintColor = .red
        self.weatherDetailLabel.text = ""
        self.temperatureLabel.text = "Error"
        self.temperatureLabel.textColor = .red
        self.windDirectionLabel.text = "Current Weather can't be optained, please check network connection and try again."
        if let error = error{
            
            self.windSpeedLabel.text = "Error: \(error.localizedDescription)"
        }
        
    }
    
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        favouriteButton = Favourite.shared.toggleSetFavouriteButton(location: location, forecast: .current, favouriteButton: favouriteButton)
    }
    
    
    
}
