//
//  Parcel.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 22/7/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import Foundation

//Model for Parcels
struct Parcel: CustomStringConvertible, Equatable, Comparable, Codable {
    //Properties
    var id: String = UUID().uuidString
    var status: Status
    var statusUpdatedDate: Date
    var trackingNo: String?
    var recipientName: String
    var deliveryAddress: String
    var deliveryDate: Date?
    var notes: String?
    
    var description: String { return "Id: \(id), Status: \(status.description()), Recipient: \(recipientName), Notes: \(notes ?? "No Notes")" }
    
    //Properties for Codable
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("parcels").appendingPathExtension("plist")
    
    //Functions
    static func loadParcels() -> [Parcel]? {
        ///Function to load data from permanent storage
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Parcel>.self, from: codedToDos)
    }
    
    static func saveParcels(_ parcels: [Parcel]){
        ///Function to  save data from permanent storage
        let propertyListEncoder = PropertyListEncoder()
        let codedParcels = try? propertyListEncoder.encode(parcels)
        try? codedParcels?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func == (lhs:Parcel, rhs: Parcel) -> Bool {
        ///Function to fullfill Comparable Equatable
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Parcel, rhs: Parcel) -> Bool {
        ///Function to fullfill Comparable protocol
        return lhs.id < rhs.id
    }
}
