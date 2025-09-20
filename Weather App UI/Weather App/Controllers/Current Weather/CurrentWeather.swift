//
//  CurrentWeather.swift
//  Weather App
//
//  Created by Andrew CP Markham on 1/9/2025.
//

import SwiftUI

struct CurrentWeather: View {

    @State private var viewModel: ViewModel

    var body: some View {
        VStack {
            TitleRow(city: viewModel.location.city, isFavourite: viewModel.isFavourite)

            HStack {

                Spacer()
                if let url = viewModel.url {
                    WeatherImageView(url: url)
                } else {
                    Image(systemName: "globe")
                        .foregroundStyle(.gray)
                        .imageScale(.large)
                        .padding()
                }
                Spacer()
                VStack {
                    Text(viewModel.location.temperatureLabel)
                    Text("Clouds")

                }
                .font(.title)
                .padding()
                Spacer()
            }
            HStack() {
                Text("Wind Direction:")
                Text(viewModel.location.windDirectionLabel)
                Spacer()
            }
            .padding()
            HStack {
                Text("Wind Speed:")
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
    init(location: Location) {
        let viewModel = ViewModel(location: location)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    NavigationStack {
        CurrentWeather(location: Location.example)
    }
}
