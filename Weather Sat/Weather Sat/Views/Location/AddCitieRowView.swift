//
//  AddLocationRowView.swift
//  Weather App
//
//  Created by Andrew CP Markham on 15/10/2025.
//

import CoreData
import SwiftUI

struct AddLocationRowView: View {

    let city: City
    @Binding var selectedCities: [City]

    var body: some View {
        Button("\( city.name) (\(city.country))") {
            self.selectedCities.append(city)
        }
    }
}

#Preview {
    AddLocationRowView(city: City.example, selectedCities: .constant([]))
}
