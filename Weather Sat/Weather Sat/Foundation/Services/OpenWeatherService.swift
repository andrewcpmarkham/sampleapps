//
//  OpenWeatherAPI.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.

import Foundation

actor OpenWeatherService {

// MARK: - Properties

    private let baseURL = URL(string: "https://api.openweathermap.org/data/3.0/onecall")!
    let urlSession: URLSession

    private var weatherResponse: WeatherResponseDTO?

    static let shared = OpenWeatherService()

    // Logical Singletop - please use init only for testing
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // Function to request weather data in single call from Oepn Weather API
    func weatherRequest(
        cityLon: Double,
        cityLat: Double,
        optionalRequest: Bool
    ) async throws -> WeatherResponseDTO {

        // 1. Get API key
        guard let apiKey = try? await KeychainManager.shared.getAPIKey() else {
            throw OpenWeatherAPIError(errorString: "API Key wasn't present for request")
        }

        // 2. Return cached response if allowed and still for today
        if let previousRequest = weatherResponse, optionalRequest {
            let timestamp = previousRequest.dailyWeather[0].dt
            let forecastDate = Date(timeIntervalSince1970: TimeInterval(timestamp))

            let isSameDay = Calendar.current.isDate(forecastDate, inSameDayAs: Date())

            if isSameDay {
                return previousRequest
            }
        }

        // 3. Build URL
        let query: [String: String] = [
            "lon": "\(cityLon)",
            "lat": "\(cityLat)",
            "units": "metric",
            "appid": apiKey
        ]

        guard let url = withQueries(baseURL, query) else {
            throw OpenWeatherAPIError(errorString: "Query applied to Base URL failed")
        }

        // 4. Perform request (async/await)
        let (data, _) = try await urlSession.data(from: url)

        // print data out for debugging
//        if let prettyJSonData = data?.asPrettyJSON() {
//            print(prettyJSonData)
//        }

        // 5. Decode
        let jsonDecoder = JSONDecoder()
        do {

            let weatherData = try jsonDecoder.decode(WeatherResponseDTO.self, from: data)
            weatherResponse = weatherData
            return weatherData
        } catch {
            // Clear cache on failed decode
            weatherResponse = nil
            throw OpenWeatherAPIError(errorString: "Weather data was not properly decoded.")
        }
    }

    // MARK: - Static helpers

    nonisolated static func getIconURL(with iconName: String) -> URL? {
        let urlString = "https://openweathermap.org/img/wn/" + iconName + "@2x.png"
        return URL(string: urlString)
    }

    private func withQueries(_ url: URL, _ queries: [String: String]) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

struct OpenWeatherAPIError: Error {
    // API Weather Error object
    let errorString: String
    init(errorString: String) {
        self.errorString = errorString
    }
}
