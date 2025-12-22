//
//  WeatherImageView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 15/9/2025.
//

import SwiftUI

struct WeatherImageView: View {
    let url: URL
    var cornerRadius: CGFloat = 12
    var contentMode: ContentMode = .fill   // .fill or .fit

    var body: some View {
        Group {
            AsyncImage(
                url: url,
                transaction: Transaction(animation: .easeOut(duration: 0.25))
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .interpolation(.medium)
                        .antialiased(true)
                        .aspectRatio(contentMode: contentMode)
                        .accessibilityLabel("Weather icon")

                case .failure:
                    Color.secondary.opacity(0.1)
                        .overlay(
                            Image(systemName: "xmark.octagon")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        )
                        .accessibilityHidden(true)

                default: // .empty
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.gray.opacity(0.25))
                            .redacted(reason: .placeholder)
                            .shimmer()
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    .accessibilityHidden(true)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .contentTransition(.opacity) // fade between phases
    }
}

#Preview {
    WeatherImageView(url: URL(string: "https://example.com/icon.png")!)
}
