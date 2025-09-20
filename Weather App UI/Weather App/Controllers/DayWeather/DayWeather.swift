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
        VStack {
            TitleRow(city: viewModel.location.city, isFavourite: viewModel.isFavourite)
            HStack {
                Text (viewModel.dateLabel)
                    .font(.title)
                    .padding()
                Spacer()
            }
            HStack {
                Text(viewModel.detailLabel)
                    .padding()
                Spacer()
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
            }
            .padding([.top, .bottom])
            HStack() {
                Text("High:")
                Text(viewModel.highTempLabel)
                Spacer()
            }
            .padding([.leading, .top])
            .padding(.bottom, 5)
            HStack() {
                Text("Low:")
                Text(viewModel.lowTempLabel)
                Spacer()
            }
            .padding(.leading)
            .padding(.bottom, 5)
            HStack() {
                Text("Wind Direction:")
                Text(viewModel.windDirectionLabel)
                Spacer()
            }
            .padding(.leading)
            .padding(.bottom, 5)
            HStack {
                Text("Wind Speed:")
                Text(viewModel.windSpeedLabel)
                Spacer()
            }
            .padding(.leading)
            .padding(.bottom, 5)
            Spacer()
        }
        .navigationTitle("24-Hour Forecast")
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
        DayWeather(location: Location.example)
    }
}
