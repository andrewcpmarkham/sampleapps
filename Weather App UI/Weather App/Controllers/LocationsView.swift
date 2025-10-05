//
//  LocationsView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 28/9/2025.
//

import SwiftUI

struct LocationsView: View {

    @State private var viewModel: ViewModel

    @State private var APIkey: String = ""

    var body: some View {
        List {
            NavigationLink(destination: Text("Hello")) {
                Text("Hello")
            }
            //LocationCollection.shared.locations
        }
        // MARK: - Toolbar
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                ToolBarButton(systemImageName: "trash") {
                    viewModel.clearButtonSelected()
                }

                ToolBarButton(systemImageName: "key", tint: viewModel.apiKeyButtonEnabled ?  Color(.label) : .red) {
                    Task {
                        viewModel.apiKeyButtonSelected()
                    }
                }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ToolBarButton(systemImageName: "plus") {
                    // TODO: - Add ability to do label here
                }
            }
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always)
        )
        // MARK: - Local use sheets and alerts
        .alert("Error",
               isPresented: .constant(viewModel.modalState == .showErrorAlert("Error"))) {
            Button("OK") {
                viewModel.modalState = .none
            }
        } message: {
            Text(viewModel.modalState.errorMessage ?? "Sorry, an unknown error has occured")
        }
        .sheet(isPresented: .constant(viewModel.modalState == .showAPIKeyAlert)) {
            APIKeyPromptSheet(modalState: $viewModel.modalState)
        }
    }

    // MARK: - Init
    init() {
        let viewModel = ViewModel()
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    NavigationStack {
        LocationsView()
    }
}
