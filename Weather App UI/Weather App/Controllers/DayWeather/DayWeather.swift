//
//  DayWeather.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

struct DayWeather: View {

    @State private var viewModel: ViewModel

    var body: some View {

        TitleRow(city: viewModel.location.city, isFavourite: viewModel.isFavourite)
        HStack {
            Text (viewModel.dateLabel)
                .font(.title)
            Spacer()
        }
        .padding()

        VStack {
            HStack {
                Text(viewModel.detailLabel)
                Spacer()
                Spacer()
                if let url = viewModel.url {
                    WeatherImageView(url: url)
                        .frame(width: 120, height: 120)
                } else {
                    Image(systemName: "globe")
                        .foregroundStyle(.gray)
                        .imageScale(.large)
                }
                Spacer()
            }
            .padding([.leading, .top, .bottom])

            HStack() {
                Text("High:")
                Text(viewModel.highTempLabel)
                Spacer()
            }
            .padding(.bottom, 5)
            HStack() {
                Text("Low:")
                Text(viewModel.lowTempLabel)
                Spacer()
            }
            .padding(.bottom, 5)
            HStack() {
                Text("Wind Direction:")
                Text(viewModel.windDirectionLabel)
                Spacer()
            }
            .padding(.bottom, 5)
            HStack {
                Text("Wind Speed:")
                Text(viewModel.windSpeedLabel)
                Spacer()
            }
            .padding(.bottom, 5)

            Spacer()
        }
        .padding(.leading)
        .navigationTitle("24-Hour Forecast")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
    }

    // MARK: - Init
    init(location: Location, weather: WeatherResponse, todaysWeather: DailyWeatherForcast) {
        let viewModel = ViewModel(location: location, weather: weather, todaysWeather: todaysWeather)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    NavigationStack {
        DayWeather(location: Location.example, weather: WeatherResponse.example, todaysWeather: DailyWeatherForcast.example )
    }
}
