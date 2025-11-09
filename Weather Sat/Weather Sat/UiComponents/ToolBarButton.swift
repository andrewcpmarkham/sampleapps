//
//  ToolBarButton.swift
//  Weather App
//
//  Created by Andrew CP Markham on 1/10/2025.
//

import SwiftUI

struct ToolBarButton: View {
    let action: () -> Void
    let buttonType: ButtonType
    var isHidden: Bool = false
    var isEnabled: Bool = true
    let tint: Color

    enum ButtonType {
        case imageButton(systemImageName: String)
        case textButton(label: String)
    }

    var body: some View {
        if !isHidden {
            buttonView()
                .disabled(!isEnabled)
                .opacity(isEnabled ? 1 : 0.4)
        }
    }

    init(buttonType: ButtonType, tint: Color = Color(.label), action: @escaping () -> Void) {
        self.buttonType = buttonType
        self.action = action
        self.tint = tint
    }

    @ViewBuilder
    private func buttonView() -> some View {
        switch buttonType {
        case .textButton(let label):
            Button(action: action) {
                Text(label)
                .tint(tint)
            }


        case .imageButton(let systemImageName):
            Button(action: action) {
                Image(systemName: systemImageName)
            }
            .tint(tint)
        }
    }
}

#Preview {
    ToolBarButton(buttonType: ToolBarButton.ButtonType.imageButton(systemImageName: "mail.fill"), action: {print("Clicked")})
}
