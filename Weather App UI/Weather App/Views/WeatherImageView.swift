//
//  WeatherImageView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 15/9/2025.
//

import SwiftUI

struct WeatherImageView: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeOut(duration: 0.25))) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .interpolation(Image.Interpolation.medium)
                    .antialiased(true)
                    .scaledToFill()
                    .accessibilityLabel("Weather icon")

            case .failure:
                Color.secondary.opacity(0.1)
                    .overlay(Image(systemName: "xmark.octagon").font(.largeTitle))
                    .accessibilityHidden(true)

            default: // .empty
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.25))
                    .redacted(reason: .placeholder)
                    .shimmer()
                    .accessibilityHidden(true)
            }
        }
        .frame(height: 160)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentTransition(.opacity) // fade between phases
    }
}

#Preview {
    WeatherImageView(url: URL(string: "https://example.com/icon.png")!)
}
