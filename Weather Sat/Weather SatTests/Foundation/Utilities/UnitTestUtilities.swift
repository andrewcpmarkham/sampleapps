//
//  UnitTestUtilities.swift
//  Weather SatTests
//
//  Created by Andrew CP Markham on 2/11/2025.
//

import Foundation
import Testing

enum UnitTestUtilities {

    /// Helper to get the Bundle when not the main Bundle as iin Unit tests
    /// - Returns: Either the Module Bundle or Unit Testing Bundle
    private static func testBundle() -> Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        final class _BundleToken {}
        return Bundle(for: _BundleToken.self)
        #endif
    }

    /// Function to load the Type from JSOB file
    /// - Parameters:
    ///   - name: FileName eg: "city.mock.data"
    ///   - ext: file extt eg. .json
    ///   - type: type of the result eg City
    ///   - configureDecoder: Hook for customisation of the decoder eg Data Formatting
    /// - Returns: Type Instances returned from JOSN eg [City, City, City]
    static func loadFixture<T: Decodable>(
        _ name: String,
        ext: String = "json",
        as type: T.Type = T.self,
        configureDecoder: ((JSONDecoder) -> Void)? = nil
    ) throws -> T {
        let bundle = testBundle()
        let url = try #require(
            bundle.url(forResource: name, withExtension: ext),
            "Missing fixture \(name).\(ext) in test bundle."
        )

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        configureDecoder?(decoder)
        return try decoder.decode(T.self, from: data)
    }

    static func loadData<T: Decodable>(
        _ dataString: String,
        as type: T.Type = T.self,
        configureDecoder: ((JSONDecoder) -> Void)? = nil
    ) throws -> T {

        let jsonData = try #require(
            dataString.data(using: .utf8) ,
            "String Data supplied could not be converted to JSON Datat."
        )
        let decoder = JSONDecoder()
        configureDecoder?(decoder)
        return try decoder.decode(T.self, from: jsonData)
    }
}
