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

    var body: some View {
        Text("\( location.city) (\(location.state), \(location.country))")
    }
}

#Preview {
    AddLocationRowView(location: Location.example)
}
