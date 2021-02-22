//
//  SWAPIEnvelope.swift
//  GenericsApp
//
//  Created by Andrew CP Markham on 21/2/21.
//

import Foundation

/// A  stata structure used to contain the people data
/// from the results data retruned from a call to the
/// Star Wars API
struct SWAPIEnvelope: Codable {
    let results: [Person]
}
