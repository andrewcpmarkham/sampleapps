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
            if viewModel.weather == nil,
               viewModel.currentWeather == nil,
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
                if let weather = viewModel.weather, let today = viewModel.dayWeather {
                    NavigationLink {
                        DayWeatherView(location: viewModel.location, weather: weather, todaysWeather: today)
                    } label: {
                        ForecastRowView(label: ViewModel.ForecastKey.dayWeather.label)
                            .padding([.top, .bottom])
                    }
                }
                if let weather = viewModel.weather, let week = viewModel.weekWeather {
                    NavigationLink {
                        WeekWeatherView(location: viewModel.location, weather: weather, weeksWeather: week)
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
    init(location: Location) {
        let viewModel = ViewModel(location: location)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    NavigationStack {
        ForecastView(location: Location.example)
    }
}
