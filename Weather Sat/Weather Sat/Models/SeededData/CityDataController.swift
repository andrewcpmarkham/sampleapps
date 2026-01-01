//
//  CoreDataController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 30/11/21.
//

import SwiftData
import Foundation

actor CityDataController {
    /**
     Class used to manage storing and retrieving Location data from  JSON file
     supplied by weather API stored in  pre seeded DB
     System is supplied with SQLite db  preloaded with JSON data due to JSON Load size
     JSON FIle is provided just in case and for developers to reload should there be a need to.
     */

    enum TypeError: Error, LocalizedError {
        case defaultDataDriectoryNotFound
        case jsonDataFileNotFound
        case jsonDataNotDecoded
        case jsonDataNotReset
        case jsonDataNotLoaded
        case seededDBFileNotFound

        var errorDescription: String {
            switch self {
            case .defaultDataDriectoryNotFound:
                return "Default Directory for Swift Data Store was not returned"
            case .jsonDataFileNotFound:
                return "Could not find JSON file with cities"
            case .jsonDataNotDecoded:
                return "Could not decode JSON city file"
            case .jsonDataNotReset:
                return "Could not reset cities in SwiftData, hence load failed"
            case .jsonDataNotLoaded:
                return "Could not load cities from JSON, hence load failed"
            case .seededDBFileNotFound:
                return "Could not find seeded sqlite file in project, hence load failed"
            }
        }
    }

    // MARK: - Main seeding Process Function

    /// Function to set stored SQLFile preset  in the prjoect as default for SwiftData
    @MainActor
    func replaceDBFilesWithSeeded() throws {

        let fm = FileManager.default
        let defaults = UserDefaults.standard

        // Default directory where the CoreDataStack will store its files
        guard let destinationDirectory = fm.urls(for: .applicationSupportDirectory,
                                                                  in: .userDomainMask).first else {
            throw TypeError.defaultDataDriectoryNotFound
        }

        // Creat app support directory
        try fm.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)

        let dataFileNames = [
            (("Cities_SwiffData", "sqlite"), ("default", "store")),
            (("Cities_SwiffData", "sqlite-shm"), ("default", "store-shm")),
            (("Cities_SwiffData", "sqlite-wal"), ("default", "store-wal"))
        ]

        // Copy each type of file from Source to Destination
        for fileNames in dataFileNames {
            let sourceName = fileNames.0
            let destinationName = fileNames.1
            if let src = Bundle.main.url(forResource: sourceName.0, withExtension: sourceName.1) {
                let dst = destinationDirectory.appendingPathComponent(destinationName.0).appendingPathExtension(destinationName.1)

                // Remove if present
                _ = try? FileManager.default.removeItem(at: dst)

                do {
                    try FileManager.default.copyItem(at: src,
                                                     to: dst)
                } catch let nserror as NSError {
                    fatalError("Error: \(nserror.localizedDescription)")
                }
            } else {
                throw TypeError.seededDBFileNotFound
            }
        }

        // Seeded data success
        defaults.hasLaunchedBefore = true
    }

    // MARK: - Main Helper Functions

    // Data load from JSON FILE
    // Requires maual copy of sql files
    @MainActor
    func preloadCities(into context: ModelContext) throws{
        // Load JSON data
        // Plan is to have the core data preloaded so this is never called
        try self.loadJSONCities(into: context)
        getSeededDataDBPath()
    }

    /// Function to read the data in from the JSON File
    @MainActor
    func loadJSONCities(into context: ModelContext) throws {
        guard
            let path = Bundle.main.path( forResource: "city.list", ofType: "json"),
            let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            throw TypeError.jsonDataFileNotFound
        }

        guard let citieDTOs = try? JSONDecoder().decode([CityDTO].self, from: json) else {
            throw TypeError.jsonDataNotDecoded
        }

        // Populate swiftData
        do {
            try context.deleteAll(of: City.self)
        } catch {
            throw TypeError.jsonDataNotReset
        }

        do {
            try load(cityDTOs: citieDTOs, into: context)
        } catch {
            throw TypeError.jsonDataNotLoaded
        }
    }

    /// Function to load CityDTOs into Swift Data
    /// - Parameter cities: Array of City Data Trasfer Objects to load
    @MainActor
    func load(cityDTOs: [CityDTO], into context: ModelContext) throws {
        try context.transaction {
            for dto in cityDTOs {
                do {
                    let city = try City(from: dto)
                    context.insert(city)
                } catch let DecodingError.valueNotFound(_, contextInfo) {
                    print("city: \(dto.name ?? "Undefined") failed with: \(contextInfo)")
                }
            }
        }
    }
    
    /// Function used to locate the SQL files used by SwiftData
    @MainActor
    func getSeededDataDBPath() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print("Pre Loaded SwiftData DB Path : \(path ?? "Not found")")
    }
}
