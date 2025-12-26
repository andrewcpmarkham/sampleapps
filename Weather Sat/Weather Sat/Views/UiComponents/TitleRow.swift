//
//  TitleRow.swift
//  Weather App
//
//  Created by Andrew CP Markham on 2/9/2025.
//

import SwiftUI

struct TitleRow: View {

    let location: Location
    let forecast: ForecastType
    @State private var isFavourite: Bool


    var city: String {
        location.city
    }

    var body: some View {
        ZStack {
            Text(city)
                .font(.title)

            HStack {
                Spacer()
                Button {
                    // TODO: - Move this into a ViewModel
                    if
                        !isFavourite,
                        let favourite = Favourite.getFavourite(for: location, forecast: forecast)
                    {
                        AppSettingsManager.shared.encode(favourite, for: .isFavourite)
                        isFavourite = true
                    } else {
                        AppSettingsManager.shared.clear(.isFavourite)
                        isFavourite = false
                    }

                } label: {
                    Image(systemName: isFavourite ?  "star.fill" :"star")
                        .imageScale(.large)
                        .padding(.trailing, 10)
                }
                .tint(isFavourite ? .yellow : .accentColor) // works here
            }
        }
        .padding()
        .background(.tertiary)
    }

    init(location: Location, forecast: ForecastType, isFavourite: Bool) {
        self.location = location
        self.forecast = forecast
        self.isFavourite = isFavourite
    }
}

#Preview {
    TitleRow(location: Location.example, forecast: .current, isFavourite: true)
}
