//
//  AddLocationRowView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 15/10/2025.
//

import CoreData
import SwiftUI

struct AddLocationRowView: View {

    let location: Location
    @Binding var selectedLocations: [Location]

    var body: some View {
        Button("\( location.city) (\(location.country))") {
            self.selectedLocations.append(location)
        }
    }
}

#Preview {
    AddLocationRowView(location: Location.example, selectedLocations: .constant([]))
}
