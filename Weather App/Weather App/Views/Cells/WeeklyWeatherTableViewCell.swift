//
//  WeeklyWeatherTableViewCell.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class WeeklyWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherDetailLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateWeekWeatherCell(with weather: WeatherResponse, index: Int) {
        // Get Icon
        // Potentially requires a thread pool here
        if
            let icon = weather.dailyWeather[index].weather.first?.icon,
            let iconURL = GetWeatherFromAPIDelegate.getIconURL(with: icon) {
            // get weather icon
            let task = URLSession.shared.dataTask(
                with: iconURL, completionHandler: { [weak self](data, _, _ ) in

                guard let data = data, let image = UIImage(data: data) else {return}
                DispatchQueue.main.async {

                    self?.weatherImage.image = image
                }
            })
            task.resume()
        }
        dateLabel.text = Date.dateOnlyFormatter.string(
            from: Date.dateFromUTCInt(
                UTCTimeStamp: weather.dailyWeather[index].dt + weather.timezoneOffset
            ))
        dateLabel.textColor = windDirectionLabel.textColor // resets back to default
        weatherDetailLabel.text = weather.dailyWeather[index].weather.first?.detail
        maxTemperatureLabel.text = "High: " + String(format: "%.0f", weather.dailyWeather[index].tempMax) + "C"
        minTemperatureLabel.text = "Low: " + String(format: "%.0f", weather.dailyWeather[index].tempMin) + "C"
        windDirectionLabel.text = "Wind Direction: \(weather.dailyWeather[index].windDirection)º"
        windSpeedLabel.text = "Wind Speed: " + String(format: "%.1f", weather.dailyWeather[index].windSpeed) + "km/h"
    }

    func updateErrorCell() {
        weatherImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
        weatherImage.tintColor = .red
        dateLabel.tintColor = .red
        dateLabel.text = "Error"
        weatherDetailLabel.isHidden = true
        maxTemperatureLabel.isHidden = true
        minTemperatureLabel.isHidden = true
        windDirectionLabel.text = "Current Weather can't be optained, please check network connection and try again."
        windDirectionLabel.numberOfLines = 2
    }
}
