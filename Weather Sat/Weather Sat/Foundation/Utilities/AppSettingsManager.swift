//
//  AppSettingsManager.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 23/11/2025.
//

import Foundation

final class AppSettingsManager {

    // Register of keys
    enum Key: String {
        case isFavourite
        case didSeedDefaults
    }

    static let shared = AppSettingsManager()

    private let defaults: UserDefaults

    // WARNING: - Conceptual Singleton, please use init only for unit testing
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Bool
    func bool(for key: AppSettingsManager.Key) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    func set(_ bool: Bool?, for key: AppSettingsManager.Key) {
        defaults.set(bool, forKey: key.rawValue)
    }

    // MARK: - Date
    func date(for key: Key) -> Date? {
        defaults.object(forKey: key.rawValue) as? Date
    }

    func set(_ date: Date?, for key: Key) {
        defaults.set(date, forKey: key.rawValue)
    }

    // MARK: - String
    func string(for key: Key) -> String? {
        defaults.string(forKey: key.rawValue)
    }

    func set(_ value: String?, for key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    // MARK: - Data
    func data(for key: Key) -> Data? {
        defaults.data(forKey: key.rawValue)
    }

    func set(_ value: Data?, for key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    // MARK: - Codable
    func decode<T: Codable>(_ type: T.Type, for key: Key) -> T? {
        guard let data = data(for: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func encode<T: Codable>(_ value: T?, for key: Key) {
        guard let value else {
            set(nil as Data?, for: key)
            return
        }
        let encoded = try? JSONEncoder().encode(value)
        set(encoded, for: key)
    }

    // MARK: - Clear
    func clear(_ key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
