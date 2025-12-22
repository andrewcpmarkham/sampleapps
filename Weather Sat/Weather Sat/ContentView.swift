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

    var body: some View {
        NavigationStack {
            LocationsView(modelContext: modelContext)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Location.self, inMemory: true)
}
