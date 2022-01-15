//
//  OpenWeatherAPI.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.

import Foundation

class GetWeatherFromAPIDelegate {

    /**
     Defaults and functionality for Open Weather API Requests
     */

    let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall")!
    let urlSession = URLSession(configuration: .default)
    private var APIKey: String? {
        // This needs to be a computed property as it doesn't update correctly
        // then the locations view controller automotically requests setting it
        // on first load of the app
        UserDefaults.standard.string(forKey: PropertyKeys.openWeatherAPIKey)
    }
    private var weatherResponse: WeatherResponse?
    // Function to request weather data in single call from Oepn Weather API
    func weatherRequest(
            cityLon: Double, cityLat: Double, optionalRequest: Bool,
            completion: @escaping (WeatherResponse?, Error?) -> Void
        ) {
        // don't proceed if there is no API Key
        guard let APIKey = self.APIKey else {
            completion(nil, OpenWeatherAPIError(errorString: "API Key wasnt present for request"))
            return
        }
        // Only call API if there isnt a previos reponse for today
        if
            let previousRequest = weatherResponse,
            optionalRequest &&
            Date.dateOnlyFormatter.string(
                from: Date.dateFromUTCInt(UTCTimeStamp: previousRequest.dailyWeather[0].dt )
            ) == Date.dateOnlyFormatter.string(from: Date()) {
                completion(previousRequest, nil)
                return
            }
        let query: [String: String] = [
            "lon": "\(cityLon)",
            "lat": "\(cityLat)",
            "units": "metric",
            "APPID": APIKey
        ]
        guard let url = baseURL.withQueries(query) else {
            completion(nil, OpenWeatherAPIError(errorString: "Query applied to Base URL failed"))
            return
        }

            let task = urlSession.dataTask(with: url) {(data, _, error) in
            let jsonDecoder = JSONDecoder()
                if
                    let dataUnwrapped = data,
                    let weatherData = try? jsonDecoder.decode( WeatherResponse.self, from: dataUnwrapped) {
                        self.weatherResponse = weatherData
                        completion(weatherData, nil)
            } else if let error = error {
                print("There was a problem with the weather request to api and no data was returned: \(error)")
                self.weatherResponse = nil
                completion(nil, error)
            } else {
                self.weatherResponse = nil
                completion(nil, OpenWeatherAPIError(errorString: "Weather data was not properly decoded."))
            }
        }
        task.resume()
    }
    static func getIconURL(with iconName: String) -> URL? {
        let urlString = "https://openweathermap.org/img/wn/" + iconName + "@2x.png"
        return URL(string: urlString)
    }
}

struct OpenWeatherAPIError: Error {
    // API Weather Error object
    let errorString: String
    init(errorString: String) {
        self.errorString = errorString
    }
}
