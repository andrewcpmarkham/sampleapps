//
//  WeekWeatherView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

struct WeekWeatherView: View {

    @State private var viewModel: ViewModel
    
    var body: some View {
        VStack {
            TitleRow(location: viewModel.location, forecast: .week)

            switch viewModel.loadState {
            case .loading:
                Text("Updataing favourite weather for \(viewModel.location.city)...")
                    .padding(.top, 20)
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.2)
                Spacer()
            default:
                // Show errro at top if recieved
                if case let LoadState.error(loadError) = viewModel.loadState {
                    HStack {
                        Text(loadError)
                            .bold()
                        Image(systemName: "exclamationmark.circle")
                            .foregroundStyle(.secondary)
                    }
                }
                ScrollView(.vertical) {
                    VStack {
                        ForEach(viewModel.weeksWeather) { day in
                            WeatherRowView(
                                weatherResponse: viewModel.weatherResponse,
                                dailyWeatherForcast: day
                            )
                            Divider()
                                .background(Color.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("7-Day Forecast")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
    }
    // MARK: - Init
    init(location: Location, weatherResponse: WeatherResponse, weeksWeather: [DailyWeatherForcast] ) {
        let viewModel = ViewModel(location: location, weatherResponse: weatherResponse, weeksWeather: weeksWeather)
        _viewModel = State(initialValue: viewModel)
    }

    // Triggered from Favourite
    init?(locationDTO: LocationDTO, weatherResponseDTO: WeatherResponseDTO, weeksWeatherDTO: [DailyWeatherForcastDTO]) {
        let weatherResponse = WeatherResponse(from: weatherResponseDTO)
        guard
            let location = Location(from: locationDTO)
        else {
            return nil
        }

        let viewModel = ViewModel(location: location, weatherResponse: weatherResponse, weeksWeather: weatherResponse.dailyWeather, loadState: .loading)
        _viewModel = State(initialValue: viewModel)

        viewModel.loadState = .loading
    }
}

#Preview {
    NavigationStack {
        WeekWeatherView(location: Location.example, weatherResponse: WeatherResponse.example, weeksWeather: [DailyWeatherForcast.example, DailyWeatherForcast.example, DailyWeatherForcast.example])
    }
}

