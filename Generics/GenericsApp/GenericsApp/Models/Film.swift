//
//  Film.swift
//  GenericsApp
//
//  Created by Andrew CP Markham on 21/2/21.
//

import Foundation

/// A film is a decodated data source for Film that are
/// recorded against people that come from the
/// star wars API

struct Film: Codable {
    let title: String
    let opening_crawl: String
    let director: String
}
