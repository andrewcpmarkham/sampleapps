//
//  Person.swift
//  GenericsApp
//
//  Created by Andrew CP Markham on 21/2/21.
//

import Foundation

/// A person is someone that has part took some role in an
/// film and used as the decodable destination for  data from the
/// star wars API
struct Person: Codable {
    let name: String
    let gender: String
    let homeworld: String
    let films: [String]
}
