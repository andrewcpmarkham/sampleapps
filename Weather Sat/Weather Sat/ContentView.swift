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
    @Query private var cities: [City]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(cities) { city in
                    NavigationLink {
                        Text("Location at \(city.name)")
                    } label: {
                        Text(city.name)
                    }
                }
                .onDelete(perform: deleteLocation)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    ToolBarButton(buttonType: .imageButton(systemImageName: "plus")) {
                        print("Cities: \(cities.count)")
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
                modelContext.delete(cities[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Location.self, inMemory: true)
}
