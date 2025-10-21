//
//  AddLocationSheet.swift
//  Weather App
//
//  Created by Andrew CP Markham on 13/10/2025.
//

import SwiftUI

struct AddLocationSheet: View {

    @State private var viewModel: ViewModel
    @Binding var modalState: LocationsView.ModalState

    var body: some View {
        // selected Locations go here
        Text("Locations Selected")
        HStack {
            // Horizontal Scroll of locations selected
            Button("Location Name") {

            }
        }

        List {
            ForEach(viewModel.locations, id: \.self) { location in
                LocationRowView(location: Location(from: location))
            }
        }

        // MARK: - Toolbar
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                ToolBarButton(buttonType: .imageButton(systemImageName: "xmark")) {
                    modalState = .none
                }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // TODO: - Make this a save button
                ToolBarButton(buttonType: .textButton(label: "Save")) {
                    modalState = .none
                }
            }
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search City...")
        )
    }

    // MARK: - Init
    init(modalState: Binding<LocationsView.ModalState>) {
        let viewModel = ViewModel()
        _viewModel = State(initialValue: viewModel)

        _modalState = modalState
    }
}

#Preview {
    NavigationStack {
        AddLocationSheet(modalState: .constant(LocationsView.ModalState.showAddLocationSheet))
    }
}
