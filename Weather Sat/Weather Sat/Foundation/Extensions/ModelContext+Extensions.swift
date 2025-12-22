//
//  ModelContext+Extensions.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 9/11/2025.
//

import Foundation
import SwiftData

extension ModelContext {
    func deleteAll<T: PersistentModel>(of type: T.Type) throws {
        let allObjects = try fetch(FetchDescriptor<T>())
        for object in allObjects {
            delete(object)
        }
        try save()
    }
}
