//
//  TitleRow.swift
//  Weather App
//
//  Created by Andrew CP Markham on 2/9/2025.
//

import SwiftUI

struct TitleRow: View {

    @State private var viewModel: ViewModel

    var body: some View {
        ZStack {
            Text(viewModel.city)
                .font(.title)

            HStack {
                Spacer()
                Button {
                    viewModel.updateFavourite()
                } label: {
                    Image(systemName: viewModel.isFavourite ?  "star.fill" :"star")
                        .imageScale(.large)
                        .padding(.trailing, 10)
                }
                .tint(viewModel.isFavourite ? .yellow : .accentColor) // works here
            }
        }
        .padding()
        .background(.tertiary)
        .onAppear {
            viewModel.isFavourite = Favourite.isFavourite(location: viewModel.location, forecast: viewModel.forecast)
        }
    }

    init(location: Location, forecast: ForecastType) {
        self.viewModel = .init(location: location, forecast: forecast)
    }
}

#Preview {
    TitleRow(location: Location.example, forecast: .current)
}
