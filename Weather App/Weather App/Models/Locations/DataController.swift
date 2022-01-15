//
//  DataController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 30/11/21.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    /**
     Class used to manage storing and retrieving Location data from  JSON file
     supplied by weather API stored in  CoreData
     System is supplied with CoreData preloaded with JSON data due to JSON Load size
     JSON FIle is provided just in case and for developers to reload should there be a need to.
     */
    var persistentContainer = NSPersistentContainer(name: PropertyKeys.locationEntityName)

    init() {
        willSetCoreData()
    }

    /// Function to read data from JSON File and Load CoreData
    /// Three sqllite files should be replaces subsequnetly for  production
    func willSetCoreData () {

        // Considerations of preloaded data
        let previouslyLaunched =
        UserDefaults.standard.bool(forKey: PropertyKeys.previouslyLaunchedKey)
        let seededDatabaseURL = Bundle.main.url(
            forResource: PropertyKeys.locationEntityName,
            withExtension: "sqlite")

        // Replacing SQL DB if it is present in package
        if  seededDatabaseURL != nil && !previouslyLaunched {
            self.seedCoreDataContainerIfFirstLaunch()
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }

        // load from JSON file and print location of file.
        // Three files: Lcoations_CoreData.sqlite, Lcoations_CoreData.sqlite, Lcoations_CoreData.sqlite
        // should be copied in to the Open Weather Project file
        if !previouslyLaunched && seededDatabaseURL == nil {
            print("Please copy sql files to the project folder for faster load time.")
            preloadLocations()
        }
    }

    /// Function to read data back from Core Data with our without a filter and sorted
    func fetchData(with searchTerm: String?) -> [NSManagedObject]? {

        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cities")
        if let searchTermIncluded = searchTerm {
            let predicate = NSPredicate(format: "(city BEGINSWITH[cd] %@)", searchTermIncluded)
            fetchRequest.predicate = predicate
        }

        let sort = NSSortDescriptor(key: "city", ascending: true)
        fetchRequest.sortDescriptors = [sort]

        do {
            let locations = try managedContext.fetch(fetchRequest)
            return locations
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
}

// MARK: Internal
extension DataController {
    // Data load from JSON FILE
    // Requires maual copy of sql files
    func preloadLocations() {
        // Load JSON data
        // Plan is to have the core data preloaded so this is never called
        self.loadJSONCities()
        getCoreDataDBPath()
    }

    func getCoreDataDBPath() {
        // Function used to locate the SQL files used by CoreDate when loaded
            let path = FileManager
                .default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .last?
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding

            print("Core Data DB Path :: \(path ?? "Not found")")
    }

    /// Function to read the data in from the JSON File
    func loadJSONCities() {
        guard
            let path = Bundle.main.path( forResource: "city.list", ofType: "json"),
                let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            print("Could not find JSON file with cities")
            return
        }

        guard let cities = try? JSONDecoder().decode([Location].self, from: json) else {
            print("Could not decode JSON city file")
            return
        }

        // Populate CoreData
        deleteALL()
        loadCitiesToCoreData(cities: cities)
    }

    /// Function to save locations to CoreData
    func loadCitiesToCoreData(cities: [Location]) {
        let managedContext = persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Cities", in: managedContext)!

        for city in cities {
            let newCity = NSManagedObject(entity: entity, insertInto: managedContext)
            newCity.setValue(city.id, forKey: "id")
            newCity.setValue(city.city, forKey: "city")
            newCity.setValue(city.country, forKey: "country")
            newCity.setValue(city.state, forKey: "state")
            newCity.setValue(city.lat, forKey: "lat")
            newCity.setValue(city.lon, forKey: "lon")
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    /// Used for Testing Purposses
    func delete(_ object: NSManagedObject) {
        persistentContainer.viewContext.delete(object)
    }

    func deleteALL() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Cities.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? persistentContainer.viewContext.execute(batchDeleteRequest)
    }
}

// MARK: Private
private extension DataController {
    /// Function to set stored SQLFile preset  for CoreData
    func seedCoreDataContainerIfFirstLaunch() {

        // Default directory where the CoreDataStack will store its files
        let directory = NSPersistentContainer.defaultDirectoryURL()
        let url = directory.appendingPathComponent(PropertyKeys.locationEntityName + ".sqlite")

        let seededDatabaseURL = Bundle.main.url(
            forResource: PropertyKeys.locationEntityName,
            withExtension: "sqlite")!

        _ = try? FileManager.default.removeItem(at: url)

        do {
            try FileManager.default.copyItem(at: seededDatabaseURL,
                                             to: url)
        } catch let nserror as NSError {
            fatalError("Error: \(nserror.localizedDescription)")
        }

        // Copying the SHM file
        let seededSHMURL = Bundle.main.url(
            forResource: PropertyKeys.locationEntityName,
            withExtension: "sqlite-shm")!
        let shmURL = directory.appendingPathComponent(
            PropertyKeys.locationEntityName + ".sqlite-shm")

        _ = try? FileManager.default.removeItem(at: shmURL)

        do {
            try FileManager.default.copyItem(at: seededSHMURL,
                                        to: shmURL)
        } catch let nserror as NSError {
            fatalError("Error: \(nserror.localizedDescription)")
        }

        // Copying the WAL file
        let seededWALURL = Bundle.main.url(
            forResource: PropertyKeys.locationEntityName,
            withExtension: "sqlite-wal")!
        let walURL = directory.appendingPathComponent(
            PropertyKeys.locationEntityName + ".sqlite-wal")

        _ = try? FileManager.default.removeItem(at: walURL)

        do {
            try FileManager.default.copyItem(at: seededWALURL,
                                        to: walURL)
        } catch let nserror as NSError {
            fatalError("Error: \(nserror.localizedDescription)")
        }
        // Seeded core data
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: PropertyKeys.previouslyLaunchedKey)
    }
}
