//
//  Data+Extensions.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/2025.
//

import Foundation

extension Data {

    /// Used to get the data as string representation for visuaising
    func DataAsString() -> String? {
        String(data: self, encoding: .utf8)
    }

    /// Used to convert JSON Data to a human readable format
    /// - Returns: Optional String of humag readable JSON
    func asPrettyJSON() -> String? {
        do {
            // Parse the JSON into a Foundation object
            let jsonObject = try JSONSerialization.jsonObject(with: self, options: [])

            // Convert the object back to Data in a pretty-printed format
            let prettyJSONData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])

            // Convert the pretty-printed Data to a String
            return String(data: prettyJSONData, encoding: .utf8)
        } catch {
            print("Error formatting JSON: \(error)")
            return nil
        }
    }
}
