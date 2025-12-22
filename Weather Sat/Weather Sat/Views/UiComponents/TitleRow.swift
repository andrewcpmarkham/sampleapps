//
//  TitleRow.swift
//  Weather App
//
//  Created by Andrew CP Markham on 2/9/2025.
//

import SwiftUI

struct TitleRow: View {

    let city: String
    @State private var isFavourite: Bool

    var body: some View {
        ZStack {
            Text(city)
                .font(.title)

            HStack {
                Spacer()
                Button {
                    isFavourite.toggle()
                } label: {
                    Image(systemName: isFavourite ?  "star.fill" :"star")
                        .imageScale(.large)
                        .padding(.trailing, 10)
                }
                .tint(isFavourite ? .yellow : .accentColor) // works here
            }
        }
        .padding()
        .background(.tertiary)
    }

    init(city: String, isFavourite: Bool) {
        self.city = city
        self._isFavourite = State(initialValue: isFavourite)
    }
}

#Preview {
    TitleRow(city: "Sydney", isFavourite: true)
}
