//
//  AddLocationTableViewCell.swift
//  Weather App
//
//  Created by Andrew CP Markham on 1/12/21.
//

import UIKit
import CoreData

class AddLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!

    // stored as selection can be interupted by mulitple quick searchs
    var locationSelected = false

    override func setSelected(_ selected: Bool, animated: Bool) {
        locationSelected = selected
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }

    func updateLocationCell(with location: NSManagedObject, at index: Int) {
        guard
            let city = location.value(forKey: "city") as? String,
                var state = location.value(forKey: "state" ) as? String,
                let country = location.value(forKey: "country")
        else {
            return
        }

        state = state != "" ? state + ", " : state

        self.locationLabel.text = "\(city), \(state)\(country)"
    }
}
