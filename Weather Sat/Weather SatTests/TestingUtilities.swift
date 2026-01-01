//
//  TestingUtilities.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 29/12/2025.
//

import Foundation

enum TestingUtilities {
    /// Provides a Random string of desirted length
    /// - Parameter length: length desired
    /// - Returns: string of random nature
    static func randomString(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
}
