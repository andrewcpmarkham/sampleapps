//
//  Status.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 1/8/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import Foundation
//Model for status - sub element of Parcels

enum Status: String, Codable{
    
    case postageRequest
    case awaitingPickup
    case dispatched
    case inTransit
    case delivered
    
    static let all: [Status] = [.postageRequest, .awaitingPickup, .dispatched, .inTransit, .delivered]

    func description() -> String{
        switch self {
        case .postageRequest:
            return "Postage Request"
        case .awaitingPickup:
            return "Awaiting Pickup"
        case .dispatched:
            return "Dispatched"
        case .inTransit:
            return "In Transit"
        case .delivered:
            return "Delivered"
        }
    }
    
    static func getFinalStatus() -> Status{
        ///Funciton to get delivered status
        return self.all[self.all.endIndex-1]
    }
    
    static func getInitialStatus() -> Status{
        ///Function to get initial status
        return self.all[0]
    }
    
    static func getRandomStatus() -> Status{
        ///Fucntion to provide a random status
        return self.all[Int.random(in: 0..<self.all.count)]
    }
    
    static func isCompleted(status: Status) -> Bool{
        ///Function to determine whether the package is complete
        return getFinalStatus() == status
    }
    
    static func isNotCompleted() -> String{
        ///Function to display appropriate text when not completed
        return "Not Delivered"
    }
}
