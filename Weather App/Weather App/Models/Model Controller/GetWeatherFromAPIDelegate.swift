//
//  OpenWeatherAPI.swift
//  Weather App
//
//  Created by Andrew CP Markham on 22/9/20.
//
//NOTE: Created as a class to ensure instance isn't copied but that the refference is passed arround
//NOTE: Would of liked to make it a singleton but decided against this to support multiple scenes.

import Foundation

class GetWeatherFromAPIDelegate {
    
    //Defaults for API request
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/onecall")!
    private let APIKey = "b138128f7ce2de0582a03cf2c0b69a0b"
    
    private var weatherResponse: WeatherResponse?
    
    //Function to request weather data in single call from API
    func weatherRequest( cityLon: Double, cityLat: Double, optionalRequest: Bool, completion: @escaping (WeatherResponse?, Error?) -> Void) {
        
        //Only call API if there isnt a previos reponse for today
        if let previousRequest = weatherResponse, optionalRequest && Date.dateOnlyFormatter.string(from: Date.dateFromUTCInt(UTCTimeStamp: previousRequest.dailyWeather[0].dt )) == Date.dateOnlyFormatter.string(from: Date()){
            completion(previousRequest, nil)
            return
        }
        
        let query: [String: String] = [
            "lon": "\(cityLon)",
            "lat": "\(cityLat)",
            "units": "metric",
            "APPID": APIKey
        ]
        
        guard let url = baseURL.withQueries(query) else{
            completion(nil, OpenWeatherAPIError(errorString: "Query applied to Base URL failed"))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data,
        response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let weatherData = try? jsonDecoder.decode(WeatherResponse.self, from: data){
                self.weatherResponse = weatherData
                completion(weatherData, nil)
            }else if let error = error{
                print("There was a problem with the weather request to api and no data was returned: \(error)")
                self.weatherResponse = nil
                completion(nil, error)
            }else{
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

struct OpenWeatherAPIError: Error{
    //API Weather Error object
    let errorString: String
    
    init(errorString: String) {
        self.errorString = errorString
    }
}
