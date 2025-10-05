//
//  ForecastView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 25/9/2025.
//

import SwiftUI

struct ForecastView: View {

    @State private var viewModel: ViewModel
    @State private var path = NavigationPath()

    var body: some View {
        List {
            if viewModel.currentWeather == nil,
               viewModel.dayWeather == nil,
               viewModel.weekWeather == nil {
                Text("Weather service is unavailable…")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                if let cw = viewModel.currentWeather {
                    NavigationLink {
                        CurrentWeatherView(location: viewModel.location, currenWeather: cw)
                    } label: {
                        ForecastRowView(label: ViewModel.ForecastKey.currentWeather.label)
                    }
                }
                if let today = viewModel.dayWeather {
                    NavigationLink {
                        DayWeatherView(location: viewModel.location, weather: viewModel.weather, todaysWeather: today)
                    } label: {
                        ForecastRowView(label: ViewModel.ForecastKey.dayWeather.label)
                            .padding([.top, .bottom])
                    }
                }
                if let week = viewModel.weekWeather {
                    NavigationLink {
                        WeekWeatherView(location: viewModel.location, weather: viewModel.weather, weeksWeather: week)
                    } label: {
                        ForecastRowView(label: ViewModel.ForecastKey.weekWeather.label)
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Init
    init(location: Location, weather: WeatherResponse) {
        let viewModel = ViewModel(location: location, weather: weather)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    NavigationStack {
        ForecastView(location: Location.example, weather: WeatherResponse.example)
    }
}
