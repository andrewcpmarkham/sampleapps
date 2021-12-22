//
//  OpenWeatherAPI.swift
//  Weather App
//
//  Created by Andrew CP Markham on 22/9/20.
//

import Foundation

class GetWeatherFromAPIDelegate {
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall")!
    private let APIKey = "b138128f7ce2de0582a03cf2c0b69a0b"
    var weatherResponse: WeatherResponse?
    func weatherRequest( cityLon: Double, cityLat: Double, completion: @escaping (WeatherResponse?, Error?) -> Void) {
        let query: [String: String] = [
            "lon": "\(cityLon)",
            "lat": "\(cityLat)",
            "units": "metric",
            "APPID": APIKey ]
        guard let url = baseURL.withQueries(query) else {
            completion(nil, OpenWeatherAPIError(errorString: "Query applied to Base URL failed"))
            print("Unable to build URL with supplied queries.")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            let jsonDecoder = JSONDecoder()
            if
                let data = data,
                let weatherData = try? jsonDecoder.decode(
                    WeatherResponse.self, from: data ) { completion(weatherData, nil
                )
            } else if let error = error {
                print("There was a problem with the weather request to api and no data was returned: \(error)")
                completion(nil, error)
            } else {
                print("Weather data was not properly decoded.")
                completion(nil, nil)
            }
        }
        task.resume()
    }
    func getIconURL(with iconName: String) -> URL? {
        let urlString = "https://openweathermap.org/img/wn/" + iconName + "@2x.png"
        return URL(string: urlString)
    }
}

struct OpenWeatherAPIError: Error {
    let errorString: String
    init(errorString: String) {
        self.errorString = errorString
    }
}
