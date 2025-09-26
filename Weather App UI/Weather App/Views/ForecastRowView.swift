//
//  ForecastRowView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 25/9/2025.
//

import SwiftUI

struct ForecastRowView: View {

    let label: String

    var body: some View {
        Text(label)
            .padding([.top, .bottom], 20)
    }
}

#Preview {
    ForecastRowView(label: "Current Weather")
}
