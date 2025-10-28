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
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 16) {
                ForEach(viewModel.locationsSelected) { locationSelected in
                    TagButton(action: viewModel.delete, location: locationSelected)
                }
            }
            .padding()
        }

        List {
            ForEach(viewModel.locations, id: \.self) { location in
                AddLocationRowView(location: Location(from: location), selectedLocations: $viewModel.locationsSelected)
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
                ToolBarButton(buttonType: .textButton(label: "Save")) {
                    viewModel.saveSelectedLocations()
                    modalState = .none
                }
                .disabled(viewModel.locationsSelected.isEmpty)
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
    @Previewable @State var modalState: LocationsView.ModalState = .showAddLocationSheet

    NavigationStack {
        AddLocationSheet(modalState: $modalState)
    }
}
