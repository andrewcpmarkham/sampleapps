//
//  KeyChainManager.swift
//  Weather App
//
//  Created by Andrew CP Markham on 4/10/2025.
//

import SwiftUI
import Security

enum KeychainError: Error, LocalizedError, Equatable {
    case apiKeyNotFound
    case unexpectedData
    case unhandledError(status: OSStatus)

    var errorDescription: String {
        switch self {
        case .apiKeyNotFound:
            return "Unable to decode access token"
        case .unhandledError(status: let status):
            return "Unhandled error: \(status)"
        case .unexpectedData:
            return "Unexpected data: unable to decode"
        }
    }
}

/// Singleton for the keychain service for storing FMCloud Auth details
// https://medium.com/@ranga.c222/how-to-save-sensitive-data-in-keychain-in-ios-using-swift-c839d0e98f9d

// WARNING: - Ensure only 1 account for service at a time
actor KeychainManager {
    static let shared = KeychainManager()

    enum Service: String {
        case openWeather = "OpenWeather"
        case mockWeather = "MockWeather"

        var account: String {
            switch self {
            case .openWeather:
                return "OpenWeatherAccount"
            case .mockWeather:
                return "MockWeatherAccount"
            }
        }
    }

    private init() {}

    // MARK: - password management

    /// Function to save the password for the serivce, removing any pre existing one
    func saveAPIKey(_ key: String, service: Service = .openWeather) throws {
        guard let data = key.data(using: .utf8) else { throw KeychainError.unexpectedData }

        let serviceName = service.rawValue
        // Try update first
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: service.account
        ]

        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]

        let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        switch updateStatus {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            // Add if missing
            let addQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecAttrAccount as String: service.account,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
                kSecValueData as String: data
            ]
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            guard addStatus == errSecSuccess else { throw KeychainError.unhandledError(status: addStatus) }
        default:
            throw KeychainError.unhandledError(status: updateStatus)
        }
    }

    func getAPIKey(service: Service = .openWeather) throws -> String {
        let serviceName = service.rawValue
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: service.account,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.apiKeyNotFound }
        guard status == errSecSuccess, let data = item as? Data,
              let key = String(data: data, encoding: .utf8) else {
            throw KeychainError.unexpectedData
        }
        return key
    }

    /// Function to remove username / password
    func deleteAPIKey(service: Service = .openWeather) throws {
        let serviceName = service.rawValue
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: service.account
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
