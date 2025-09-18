//
//  AddLocationCollectionViewCell.swift
//  Weather App
//
//  Created by Andrew CP Markham on 3/1/22.
//

import UIKit
import CoreData

class AddLocationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionLabel: UILabel!

    var locationID: Int!

    func updateLocationCell(with location: NSManagedObject, at index: Int) {
        guard
            let city = location.value(forKey: "city") as? String,
            var state = location.value(forKey: "state" ) as? String,
            let country = location.value(forKey: "country") as? String,
            let locationID = location.value(forKey: "id") as? Int
        else {
            return
        }
        state = state != "" ? state + ", " : state

        self.collectionLabel.text = "\(city) (\(state)\(country))"
        self.locationID = locationID
    }
}
