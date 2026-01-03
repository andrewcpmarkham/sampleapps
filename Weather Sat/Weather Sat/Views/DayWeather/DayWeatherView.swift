//
//  DayWeatherView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

struct DayWeatherView: View {

    @State private var viewModel: ViewModel

    var body: some View {

        TitleRow(location: viewModel.location, forecast: .day)

        VStack {
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
            }
        }
        .padding(.leading)
        .navigationTitle("24-Hour Forecast")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
    }

    // MARK: - Init
    init(location: Location, weatherResponse: WeatherResponse, todaysWeather: DailyWeatherForcast) {
        let viewModel = ViewModel(location: location, weatherResponse: weatherResponse, dayWeather: todaysWeather)
        _viewModel = State(initialValue: viewModel)
    }

    // Triggered from Favourite
    init?(locationDTO: LocationDTO, weatherResponseDTO: WeatherResponseDTO, dayWeatherDTO: DailyWeatherForcastDTO) {

        guard let location = Location(from: locationDTO) else {
            return nil
        }
        let weatherResponse = WeatherResponse(from: weatherResponseDTO)

        let viewModel = ViewModel(location: location, weatherResponse: weatherResponse, dayWeather: DailyWeatherForcast(from: dayWeatherDTO), loadState: .loading)
        _viewModel = State(initialValue: viewModel)

        viewModel.loadState = .loading
    }
}

#Preview {
    NavigationStack {
        DayWeatherView(location: Location.example, weatherResponse: WeatherResponse.example, todaysWeather: DailyWeatherForcast.example )
    }
}
