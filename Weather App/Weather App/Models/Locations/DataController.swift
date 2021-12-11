//
//  DataController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 30/11/21.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: PropertyKeys.cityEntityID)

        // Used for testing where we don't want storage maintained
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    //Load the Data from the JSON File
    func loadJSONCities() -> [Location]?{
        guard let  path = Bundle.main.path(forResource: "city.list", ofType: "json"), let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            return nil
        }

        guard  let cities = try? JSONDecoder().decode([Location].self, from: json) else {
            return nil
        }

        return cities
    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    //Used for Testing Purposses
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

//    func deleteALL() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Cities.fetchRequest()
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        _ = try? container.viewContext.execute(batchDeleteRequest)
//    }
}
