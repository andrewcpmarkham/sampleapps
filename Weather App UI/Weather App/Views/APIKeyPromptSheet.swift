//
//  APIKeyPromptSheet.swift
//  Weather App
//
//  Created by Andrew CP Markham on 5/10/2025.
//

import SwiftUI

struct APIKeyPromptSheet: View {

    @Binding var modalState: LocationsView.ModalState
    @State private var apiKey: String = ""
    @State private var disableSheet: Bool = true

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("OpenWeather API Key")
                    .font(.headline)
                    .padding(.bottom, 20)
                TextField("Enter API key…", text: $apiKey)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled()
                    .monospaced()
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled()
                    .monospaced()
            }
            .padding([.leading, .trailing], 50)
            .onChange(of: apiKey) {
                disableSheet = apiKey.isEmpty
            }
            Spacer()
            HStack(spacing: 20) {
                AlertButton(title: "Ok", action: {handleOnSave()}, isDisabled: $disableSheet)
                AlertButton(title: "Cancel", action: {
                    modalState = .none
                }, isDisabled: .constant(false))
            }
            Spacer()
        }
        .background(Color.systemGroupedBackground)
        .navigationTitle("API Key")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { modalState = .none }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    handleOnSave()
                }
                .disabled(apiKey.isEmpty)
            }
        }
    }

    func handleOnSave() {
        let key = apiKey
        Task { @MainActor in
            do {
                try await KeychainManager.shared.saveAPIKey(key)
                modalState = .none
            } catch {
                modalState = .showErrorAlert("Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    APIKeyPromptSheet(modalState: .constant(.showAPIKeyAlert))
}
