//
//  PropertyKeys.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 29/7/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import UIKit

struct PropertyKeys {
    //Identifiers used in the program
    
    //Segue indentifiers
    static let segueSaveUnwind = "SaveUnwind"
    static let segueCancelUnwind = "CancelUnwind"
    static let segueSaveEditUnwind = "SaveEditUnwind"
    static let segueDeleteUnwind = "DeleteUnwind"
    static let segueEditParcel = "EditParcel"
    static let segueAddParcel = "AddParcel"
    static let segueSelectStatus = "SelectStatus"
    static let segueEditStatus = "EditStatus"
    static let segueStatusUnwind = "UnwindToParcelDetail"
    
    //Cell Identifiers
    static let cellStatusCell = "StatusCell"
    
    //Image Identifiers
    static let imageCheckMark = "checkmark.circle"
    static let imageCheckMarkEmpty = "circle"
    
    //TableSettings
    static let parcelTableViewSections = 1
    static let parcelTableViewHeaderRowHeight = CGFloat(64.0)
    static let parcelCellIdentifier = "ParcelCellIdentifier"
    static let parcelHeaderIdentifier = "ParcelHeaderIdentifier"
    static let parcelHeaderCollumn1 = "Name"
    static let parcelHeaderCollumn2 = "Address"
    static let parcelHeaderCollumn3 = "Status"
    
    //Status Selection Settings
    static let statusSelectionViewSections = 1
    
    
    //Date Formatter
    static let dateFormatter: DateFormatter = {
        ///Function for default date and tiem format in program
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}


