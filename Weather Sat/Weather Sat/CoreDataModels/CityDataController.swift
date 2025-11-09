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

    // MARK: - Main seeding Process Function
    /// Function to read data from JSON File and Seed Data if needed
    /// Three sqllite files should be replaces subsequnetly for  production
    @MainActor
    func seedData(context: ModelContext) {

        // Considerations of preloaded data
        let previouslyLaunched =
        UserDefaults.standard.bool(forKey: PropertyKeys.previouslyLaunchedKey)

        if
            !previouslyLaunched,
            let seededDatabaseURL = Bundle.main.url(
                forResource: PropertyKeys.cityEntityName,
                withExtension: "sqlite")
        {
            // Set Seeded SQL DB if it is present in package
            // Three files: Lcoations_CoreData.sqlite, Lcoations_CoreData.sqlite, Lcoations_CoreData.sqlite
            // should be copied in to the Open Weather Project file
            self.replaceDBFilesWithSeeded()

        } else if
            !previouslyLaunched
        {
            // load from JSON file and print location of file.
            print("Please copy sql files to the project folder for faster load time.")
            preloadCities(into: context)
        }
    }

    // MARK: - Private Functions
    /// Function to set stored SQLFile preset  for CoreData
    @MainActor
    private func replaceDBFilesWithSeeded() {
//
//        // Default directory where the CoreDataStack will store its files
//        let directory = NSPersistentContainer.defaultDirectoryURL()
//        let url = directory.appendingPathComponent(PropertyKeys.locationEntityName + ".sqlite")
//
//        let seededDatabaseURL = Bundle.main.url(
//            forResource: PropertyKeys.locationEntityName,
//            withExtension: "sqlite")!
//
//        _ = try? FileManager.default.removeItem(at: url)
//
//        do {
//            try FileManager.default.copyItem(at: seededDatabaseURL,
//                                             to: url)
//        } catch let nserror as NSError {
//            fatalError("Error: \(nserror.localizedDescription)")
//        }
//
//        // Copying the SHM file
//        let seededSHMURL = Bundle.main.url(
//            forResource: PropertyKeys.locationEntityName,
//            withExtension: "sqlite-shm")!
//        let shmURL = directory.appendingPathComponent(
//            PropertyKeys.locationEntityName + ".sqlite-shm")
//
//        _ = try? FileManager.default.removeItem(at: shmURL)
//
//        do {
//            try FileManager.default.copyItem(at: seededSHMURL,
//                                        to: shmURL)
//        } catch let nserror as NSError {
//            fatalError("Error: \(nserror.localizedDescription)")
//        }
//
//        // Copying the WAL file
//        let seededWALURL = Bundle.main.url(
//            forResource: PropertyKeys.locationEntityName,
//            withExtension: "sqlite-wal")!
//        let walURL = directory.appendingPathComponent(
//            PropertyKeys.locationEntityName + ".sqlite-wal")
//
//        _ = try? FileManager.default.removeItem(at: walURL)
//
//        do {
//            try FileManager.default.copyItem(at: seededWALURL,
//                                        to: walURL)
//        } catch let nserror as NSError {
//            fatalError("Error: \(nserror.localizedDescription)")
//        }
//        // Seeded core data
//        let defaults = UserDefaults.standard
//        defaults.set(true, forKey: PropertyKeys.previouslyLaunchedKey)
    }

    // MARK: - Main Helper Functions

    // Data load from JSON FILE
    // Requires maual copy of sql files
    @MainActor
    func preloadCities(into context: ModelContext) {
        // Load JSON data
        // Plan is to have the core data preloaded so this is never called
        self.loadJSONCities(into: context)
        getSeededDataDBPath()
    }

    /// Function to read the data in from the JSON File
    @MainActor
    func loadJSONCities(into context: ModelContext) {
        guard
            let path = Bundle.main.path( forResource: "city.list", ofType: "json"),
            let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            print("Could not find JSON file with cities")
            return
        }

        guard let citieDTOs = try? JSONDecoder().decode([CityDTO].self, from: json) else {
            print("Could not decode JSON city file")
            return
        }

        // Populate swiftData
        do {
            try context.deleteAll(of: City.self)
        } catch {
            print("Could not reset cities in SwiftData, hence load failed")
            return
        }

        do {
            try load(cityDTOs: citieDTOs, into: context)
        } catch {
            print("Could not load cities from JSON, hence load failed")
            return
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
