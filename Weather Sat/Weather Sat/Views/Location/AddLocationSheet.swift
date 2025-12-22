//
//  AddLocationSheet.swift
//  Weather App
//
//  Created by Andrew CP Markham on 13/10/2025.
//

import SwiftData
import SwiftUI

struct AddLocationSheet: View {

    @State private var viewModel: ViewModel
    @Binding var modalState: LocationsView.ModalState

    var body: some View {
        // selected Cities go here
        Text("Locations Selected")
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 16) {
                ForEach(viewModel.citiesSelected) { citySelected in
                    TagButton(action: viewModel.delete, city: citySelected)
                }
            }
            .padding()
        }

        // Cities to select from
        List {
            ForEach(viewModel.cities, id: \.self) { city in
                AddLocationRowView(city: city, selectedCities: $viewModel.cities)
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
                    saveLocations()
                }
                .disabled(viewModel.citiesSelected.isEmpty)
            }
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: Text("Search City...")
        )
    }

    // TODO: - PASS MODEL CONTEXT INTO HERE.
    // MARK: - Init
    init(modalState: Binding<LocationsView.ModalState>, modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)

        _modalState = modalState
    }

    func saveLocations() {
        do {
            try viewModel.saveSelectedCities()
            modalState = .none
        } catch {
            modalState = .showErrorAlert("There was an error saving the chosen locations. Please try again.")
        }
    }
}

#Preview {
    @Previewable @State var modalState: LocationsView.ModalState = .showAddLocationSheet

    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: City.self, configurations: config)

    container.mainContext.insert(City.example)

    return NavigationStack {
        AddLocationSheet(
            modalState: $modalState,
            modelContext: container.mainContext
        )
    }
}
