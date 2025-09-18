//
//  Controller+Helper.swift
//  Cluey
//
//  Created by Andrew CP Markham on 7/8/2022.
//

import UIKit

extension URL {

    func withQueries(_ queries: [String: String]) -> URL? {
        /// Function to support query parameter inclusion to URL structure
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map {
            URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
