//
//  LocationsTableViewCell.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateLocationCell(with location: Location, at index: Int){
        //Update  UI with weather request data and always perform as it is current weather

        self.locationLabel.text = "\(location.city!), \(location.country!)"

        location.getWeatherFromAPIDelegate.weatherRequest(cityLon: location.lon!, cityLat: location.lat!, optionalRequest: false, completion: {
            [weak self] (weather, error) in
            guard let weather = weather else {
                DispatchQueue.main.async {
                    //Error
                    self?.networkErrorNotification(error: error)
                }
                return
            }

            DispatchQueue.main.async {
                LocationCollection.shared.willSetWeatherForLocationAtIndex(at: index, with: weather)
                self?.temperatureLabel.text = String(format: "%.0f", weather.temp) + "C"
            }
        })
    }

    func networkErrorNotification(error: Error?){
        //Function to update UI based on netork error
        self.temperatureLabel.text = "?"

    }
}
