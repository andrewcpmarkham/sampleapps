//
//  URL+Helpers.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

extension URL {
    
    func withQueries(_ queries: [String: String]) -> URL?{
        //Function to support query parameter inclusion to URL structure
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map{
            URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
