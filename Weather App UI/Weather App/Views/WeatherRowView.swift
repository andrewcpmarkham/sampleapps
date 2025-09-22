//
//  WeatherRowView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

struct WeatherRowView: View {

    @State private var viewModel: ViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text (viewModel.dateLabel)
                    .font(.title2)
                Text(viewModel.detailLabel)
                    .font(.title2)
            }
            Spacer()
            if let url = viewModel.url {
                WeatherImageView(url: url, contentMode: .fill)
                    .frame(width: 80, height: 80)
            } else {
                Image(systemName: "globe")
                    .foregroundStyle(.gray)
                    .imageScale(.large)
            }
        }
        .padding([.leading, .trailing])

        VStack(alignment: .leading) {
            HStack() {
                Text("High:")
                    .bold()
                Text(viewModel.highTempLabel)
            }
            HStack() {
                Text("Low:")
                    .bold()
                Text(viewModel.lowTempLabel)
            }
            HStack() {
                Text("Wind Direction:")
                    .bold()
                Text(viewModel.windDirectionLabel)
            }
            HStack {
                Text("Wind Speed:")
                    .bold()
                Text(viewModel.windSpeedLabel)
                Spacer()
            }
        }
        .padding(.leading)
    }

    // MARK: - Init
    init(weather: WeatherResponse, dailyWeatherForcast: DailyWeatherForcast) {
        let viewModel = ViewModel(weather: weather, dailyWeatherForcast: dailyWeatherForcast)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    WeatherRowView(weather: WeatherResponse.example, dailyWeatherForcast: DailyWeatherForcast.example)
}
