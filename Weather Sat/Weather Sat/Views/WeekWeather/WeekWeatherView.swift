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
            TitleRow(location: viewModel.location, forecast: .week, isFavourite: viewModel.isFavourite)
            ScrollView(.vertical) {
                VStack {
                    ForEach(viewModel.weeksWeather) { day in
                        WeatherRowView(
                            weather: viewModel.weather,
                            dailyWeatherForcast: day
                        )
                        Divider()
                            .background(Color.secondary)
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
    init(location: Location, weather: WeatherResponse, weeksWeather: [DailyWeatherForcast] ) {
        let viewModel = ViewModel(location: location, weather: weather, weeksWeather: weeksWeather)
        _viewModel = State(initialValue: viewModel)
    }

    init?(locationDTO: LocationDTO, weatherDTO: WeatherResponseDTO, weeksWeatherDTO: [DailyWeatherForcastDTO]) {
        guard let location = Location(from: locationDTO)
        else { return nil }

        self.init(location: location, weather: WeatherResponse(from: weatherDTO), weeksWeather: weeksWeatherDTO.compactMap{ DailyWeatherForcast(from: $0)})
    }
}

#Preview {
    NavigationStack {
        WeekWeatherView(location: Location.example, weather: WeatherResponse.example, weeksWeather: [DailyWeatherForcast.example, DailyWeatherForcast.example, DailyWeatherForcast.example])
    }
}

