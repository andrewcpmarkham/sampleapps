//
//  ToolBarButton.swift
//  Weather App
//
//  Created by Andrew CP Markham on 1/10/2025.
//

import SwiftUI

struct ToolBarButton: View {
    let systemImageName: String
    let action: () -> Void
    let tint: Color

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImageName)
        }
        .tint(tint)
    }

    init(systemImageName: String, tint: Color = Color(.label), action: @escaping () -> Void) {
        self.systemImageName = systemImageName
        self.action = action
        self.tint = tint
    }
}

#Preview {
    ToolBarButton(systemImageName: "mail.fill", action: {print("Clicked")})
}
