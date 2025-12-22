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

    let location: Location

    enum LoadState {
        case loading
        case success(String)     // e.g. "22°"
        case error(String)       // e.g. "?"
    }

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

    @MainActor
    private func setError() {
        state = .error("?")
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
            print("Failed to fetch weather: \(error)")
            await MainActor.run {
                networkErrorNotification(error: error)
                setError()
            }
        }
    }

    @MainActor
    func networkErrorNotification(error: Error?) {
        // Update any UI-facing error indicators here if needed
        // (state is already set to .error("?"))
    }
}

#Preview {
    LocationRowView(location: Location.example)
}
