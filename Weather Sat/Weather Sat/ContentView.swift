//
//  ContentView.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 1/11/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var locations: [Location]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(locations) { location in
                    NavigationLink {
                        Text("Location at \(location.city)")
                    } label: {
                        Text(location.city)
                    }
                }
                .onDelete(perform: deleteLocation)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    ToolBarButton(buttonType: .imageButton(systemImageName: "plus")) {
                        loadCities() 
                    }
                }
            }
        } detail: {
            Text("Select an Location")
        }
    }


    private func deleteLocation(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(locations[index])
            }
        }
    }

    private func loadCities() {
        let cityDataController = CityDataController()
        cityDataController.seedData(context: modelContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Location.self, inMemory: true)
}
