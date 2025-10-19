//
//  LocationRowView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 10/10/2025.
//

import CoreData
import SwiftUI

struct LocationRowView: View {
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

        // Keep your existing API shape; adapt to async if you can.
        await withCheckedContinuation { continuation in
            location.getWeatherFromAPIDelegate.weatherRequest(
                cityLon: location.lon,
                cityLat: location.lat,
                optionalRequest: false
            ) { weather, error in
                if let weather {
                    // If you must touch shared models, do it off the view where possible.
                    if let index = LocationCollection.shared.getAllLocations().firstIndex(of: location) {
                        DispatchQueue.main.async {
                            LocationCollection.shared.willSetWeatherForLocationAtIndex(at: index, with: weather)
                            setSuccess(weather.temp)  // main-actor method
                            continuation.resume()
                        }
                    } else {
                        DispatchQueue.main.async {
                            setError()
                            continuation.resume()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        networkErrorNotification(error: error)
                        setError()
                        continuation.resume()
                    }
                }
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
