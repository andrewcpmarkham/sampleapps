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
            ForEach(viewModel.filteredLocations, id: \.self) { location in
                NavigationLink(value: location) {
                    LocationRowView(location: location)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.delete(location)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }

        // MARK: - Toolbar
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                ToolBarButton(buttonType: .imageButton(systemImageName: "trash")) {
                    viewModel.clearButtonSelected()
                }

                ToolBarButton(buttonType: .imageButton(systemImageName: "key"), tint: viewModel.apiKeyButtonEnabled ?  Color(.label) : .red) {
                    viewModel.apiKeyButtonSelected()
                }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ToolBarButton(buttonType: .imageButton(systemImageName: "plus")) {
                    viewModel.modalState = .showAddLocationSheet
                }
                .disabled(!viewModel.addLocationButtonEnabled)
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
            APIKeyPromptSheet(modalState: $viewModel.modalState, onDismiss: viewModel.updateToolBarButtonStates)
        }
        .sheet(isPresented: .constant(viewModel.modalState == .showAddLocationSheet)) {
            AddLocationSheet(modalState: $viewModel.modalState)
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
