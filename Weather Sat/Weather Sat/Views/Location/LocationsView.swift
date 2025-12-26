//
//  LocationsView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 28/9/2025.
//

import SwiftData
import SwiftUI

//struct WeatherRouterView: View {
//    let location: Location
//    let weather: WeatherResponse
//    let type: ForecastType
//
//
//    var body: some View {
//        switch type {
//        case .current:
//            CurrentWeatherView(location: location, currenWeather: weather.weather.first)
//        case .day:
//            DayWeatherView(location: location, todaysWeather: currentWeather)
//        case .week:
//            WeekWeatherView(location: location)
//        }
//    }
//}

struct LocationsView: View {

    @State private var viewModel: ViewModel

    @State private var APIkey: String = ""

    var body: some View {
        List {
            ForEach(viewModel.filteredLocations, id: \.self) { location in
                NavigationLink {
                    ForecastView(location: location)
                } label: {
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
            .alert("Error",
                   isPresented: .constant(viewModel.modalState == .showErrorAlert("Error"))) {
                Button("OK") {
                    viewModel.modalState = .none
                }
            } message: {
                Text(viewModel.modalState.errorMessage ?? "Sorry, an unknown error has occured")
            }
        }

        // MARK: - Toolbar
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                ToolBarButton(buttonType: .imageButton(systemImageName: "trash")) {
                    viewModel.modalState = .showDeleteAlert
                }
                .disabled(viewModel.filteredLocations.isEmpty)

                ToolBarButton(buttonType: .imageButton(systemImageName: "key"), tint: viewModel.apiKeyStored ?  Color(.label) : .red) {
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
            placement: .navigationBarDrawer(displayMode: .automatic)
        )
        // MARK: - Local use sheets and alerts
        .alert("Delete All Locations", isPresented: .constant(viewModel.modalState == .showDeleteAlert)) {
            Button("Yes") {
                viewModel.modalState = .none
                withAnimation {
                    viewModel.deleteAllButtonSelected()
                    viewModel.loadData()
                }
            }
            Button("Cancel") {viewModel.modalState = .none}
        } message: {
            Text("Are you sure you wish to delete all locations?")
        }
        .sheet(isPresented: .constant(viewModel.modalState == .showAPIKeyAlert)) {
            APIKeyPromptSheet(modalState: $viewModel.modalState, onDismiss: apiKeyEntered)
                .interactiveDismissDisabled(true)
        }
        .sheet(isPresented: .constant(viewModel.modalState == .showAddLocationSheet)) {
            AddLocationSheet(modalState: $viewModel.modalState, modelContext: viewModel.modelContext, onDismiss: viewModel.loadData)
        }
    }

    // MARK: - Init
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }

    // MARK: - Functions
    func apiKeyEntered() {
        Task {
            await viewModel.updateToolBarButtonStates()

            if viewModel.apiKeyStored {
                viewModel.loadData()
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: City.self, configurations: config)

    return NavigationStack {
        LocationsView(modelContext: container.mainContext)
    }
}
