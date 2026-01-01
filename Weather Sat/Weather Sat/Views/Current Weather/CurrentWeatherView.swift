//
//  CurrentWeatherView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 1/9/2025.
//

import SwiftUI

struct CurrentWeatherView: View {

    @State private var viewModel: ViewModel

    var body: some View {
        VStack {
            TitleRow(location: viewModel.location, forecast: .current, isFavourite: viewModel.isFavourite)

            HStack {

                Spacer()
                if let url = viewModel.url {
                    WeatherImageView(url: url)
                        .frame(width: 120, height: 120)
                } else {
                    Image(systemName: "globe")
                        .foregroundStyle(.gray)
                        .imageScale(.large)
                        .padding()
                }
                Spacer()
                VStack {
                    Text(viewModel.location.temperatureLabel)
                    .bold()
                    Text(viewModel.location.weatherDetailLabel)

                }
                .font(.title)
                .padding()
                Spacer()
            }
            HStack() {
                Text("Wind Direction:")
                    .bold()
                Text(viewModel.location.windDirectionLabel)
                Spacer()
            }
            .padding()
            HStack {
                Text("Wind Speed:")
                    .bold()
                Text(viewModel.location.windSpeedLabel)
                Spacer()
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Current Weather")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
    }

    // MARK: - Init
    init(location: Location, currenWeather: WeatherObservation) {
        let viewModel = ViewModel(location: location, currenWeather: currenWeather)
        _viewModel = State(initialValue: viewModel)
    }

    init?(locationDTO: LocationDTO, weatherResponseDTO: WeatherResponseDTO? = nil, currenWeatherDTO: WeatherObservationDTO) {
        guard
            let location = Location(from: locationDTO)
        else {
            return nil
        }

        // Required for Favourite where weather detail need to be resupplied to the location
        if let weatherResponseDTO = weatherResponseDTO {
            location.weather = WeatherResponse(from: weatherResponseDTO)
        }
        self.init(location: location, currenWeather: WeatherObservation(from: currenWeatherDTO))
    }
}

#Preview {
    NavigationStack {
        CurrentWeatherView(location: Location.example, currenWeather: WeatherObservation.example)
    }
}
