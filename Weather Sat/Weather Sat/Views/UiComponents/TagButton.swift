//
//  TagButton.swift
//  Weather App
//
//  Created by Andrew CP Markham on 27/10/2025.
//

import SwiftUI

struct TagButton: View {
    let action: (City) -> Void
    let city: City

    private var label: String { "\(city.name) \(city.country)" }

    var body: some View {
        Button {
            action(city)
        } label: {
            HStack(spacing: 8) {
                Text(label)
                    .font(.headline)
                Image(systemName: "xmark")
                    .imageScale(.small)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(label), remove")
    }
}

#Preview {
    TagButton(action: { _ in print("Clicked") }, city: .example)
        .padding()
}
