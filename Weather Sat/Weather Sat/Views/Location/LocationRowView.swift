//
//  LocationRowView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 10/10/2025.
//

import SwiftData
import SwiftUI

struct LocationRowView: View {
    @Environment(\.modelContext) private var modelContext

    var location: Location

    @State private var state: LoadState = .loading

    var body: some View {
        HStack {
            Text("\(location.city), \(location.country)")
            Spacer()

            switch state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.2)
            case .success(let temp):
                Text(temp)
                    .monospacedDigit()
            case .error(_):
                Image(systemName: "exclamationmark.circle")
                    .foregroundStyle(.secondary)
            }
        }
        // Runs when the row appears and whenever the location changes (if it’s Identifiable)
        .task(id: location.id) {
            await getLocationWeather()
        }
    }

    // MARK: - Networking
    @MainActor
    private func setSuccess(_ tempCelsius: Double) {
        let formatted = String(format: "%.0f°", tempCelsius) // or add “C” if you like
        state = .success(formatted)
    }

    private func getLocationWeather() async {
        state = .loading

        do {
            let weatherDTO = try await OpenWeatherService.shared.weatherRequest(
                cityLon: location.lon,
                cityLat: location.lat,
                optionalRequest: false
            )

            await MainActor.run {
                location.weather = WeatherResponse(from: weatherDTO)
                setSuccess(weatherDTO.temp)
            }
        } catch {
            await MainActor.run {
                state = .error("Failed to fetch weather: \(error)")
            }
        }
    }
}

#Preview {
    LocationRowView(location: Location.example)
}

enum LoadState: Equatable {
    case loading
    case success(String)
    case error(String)

    static func == (lhs: LoadState, rhs: LoadState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.success(_), .success(_)):
            return true
        case (.error(_), .error(_)):
            return true
        default:
            return false
        }
    }
}

enum networkRequestResult {
    case success(WeatherResponseDTO)
    case failure(Error)
}

protocol locationWeatherGetter {
    var viewState: LoadState { get set }
    var location: Location { get set }

    func getLocationWeather() async

    func updateView(for: networkRequestResult)
}

extension locationWeatherGetter {
    private mutating func getLocationWeather() async {
        viewState = .loading

        do {
            let weatherDTO = try await OpenWeatherService.shared.weatherRequest(
                cityLon: location.lon,
                cityLat: location.lat,
                optionalRequest: false
            )

            updateView(for: .success(weatherDTO))
        } catch {
            updateView(for: .failure(error))
        }
    }
}
