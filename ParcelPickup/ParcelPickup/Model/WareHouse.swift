//
//  WareHouse.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 5/8/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import Foundation

struct Warehouse {
    
    static func getSampleParcels() -> [Parcel]{
        ///Function to provide sample data
        let parcel1 = Parcel( status: Status.getInitialStatus(), statusUpdatedDate: Date(), trackingNo: "1", recipientName: "Peter Smith", deliveryAddress: "12 George St, Sydney, 2000")
        let parcel2 = Parcel(status: Status.getRandomStatus(), statusUpdatedDate: Date(), trackingNo: "2", recipientName: "John Thomas", deliveryAddress: "81 Victoria Rd, Parramatta, 2150", notes: "Followed up parcel delivery with courier for an estimated Date - \(Date())")
        let parcel3 = Parcel(status: Status.getFinalStatus(), statusUpdatedDate: Date(), trackingNo: "3", recipientName: "Betty Green", deliveryAddress: "17 Gladstone Ave, Castle Hill, 2154", deliveryDate: Date(), notes: "Left at front door step")
        return [parcel1, parcel2, parcel3]
    }
}
