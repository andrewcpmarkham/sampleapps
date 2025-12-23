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

    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            // selected Cities go here
            Text(viewModel.citiesSelected.isEmpty ? "No Locations Selected" :"Locations Selected")
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
                switch viewModel.loadStatus {
                case .loading:
                    VStack {
                        Text("Loading cities of the world...")
                            .tint(Color(.systemBlue))
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.25))
                                .redacted(reason: .placeholder)
                                .shimmer()
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
                case .loaded:
                    ForEach(viewModel.filteredCities, id: \.self) { city in
                        AddLocationRowView(city: city, selectedCities: $viewModel.citiesSelected)
                    }
                case .error:
                    Text("There was an error loading cities. Please try again.")
                        .tint(Color(.systemRed))
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
                        onDismiss()
                    }
                    .disabled(viewModel.citiesSelected.isEmpty)
                }
            }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: Text("Search City...")
            )
        }
    }

    // MARK: - Init
    init(modalState: Binding<LocationsView.ModalState>, modelContext: ModelContext, onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
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
            modelContext: container.mainContext, onDismiss: {print("View Dismissed!")}
        )
    }
}
