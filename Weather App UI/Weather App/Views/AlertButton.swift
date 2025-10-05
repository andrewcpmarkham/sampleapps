//
//  AlertButton.swift
//  Weather App
//
//  Created by Andrew CP Markham on 6/10/2025.
//

import SwiftUI

struct AlertButton: View {
    let title: String
    let action: () -> Void
    @Binding var isDisabled: Bool

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(minWidth: 75)
                .foregroundColor(.white)
                .padding()
                .background(isDisabled ? .gray : .blue)
                .cornerRadius(8)
                .opacity(isDisabled ? 0.5 : 1)
        }
        .disabled(isDisabled)
    }
}

#Preview {
    AlertButton(title: "Test", action: {print("Clicked")}, isDisabled: .constant(false))
}
