//
//  WeekWeather.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import SwiftUI

struct WeekWeather: View {

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
        }
        .navigationTitle("7-Day Forecast")
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
        WeekWeather(location: Location.example)
    }
}

