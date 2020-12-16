//
//  GetLocationFromAPIDelegate.swift
//  Weather App
//
//  Created by Andrew CP Markham on 30/9/20.
//

import Foundation

struct GetLocationFromAPIDelegate {
    
    //Defaults for API request
    private let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    private let APIKey = "b138128f7ce2de0582a03cf2c0b69a0b"
    
    func fetchMatchingLocationsByName(with searchTerm: String,completion: @escaping (Location?, Error?) -> Void) {
        //Function to seach for Locations from OpenWeather API based on city name and possibility country code ie Sydney, AU
            
        // set up query dictionary
        //Seatch term can be {city name},{state code},{country code} or combination eg London,uk
        let query: [String: String] = [
            "q": searchTerm,
            "APPID": APIKey
        ]
            
            
        // perform the search
        guard let url = baseURL.withQueries(query) else{
            completion(nil, OpenWeatherAPIError(errorString: "Query applied to Base URL failed"))
            return
        }
            
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let weatherData = try? jsonDecoder.decode(Location.self, from: data){
                completion(weatherData, nil)
            }else if let error = error{
                print("There was a problem with the weather request to api and no data was returned: \(error)")
                completion(nil, error)
            }else{
                completion(nil, OpenWeatherAPIError(errorString: "Weather data was not properly decoded."))
            }
        }
        task.resume()
    }
}
