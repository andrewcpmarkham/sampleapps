//
//  LocationsTableViewCell.swift
//  Weather App
//
//  Created by Andrew CP Markham on 20/9/20.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateLocationCell(with location: Location){
        locationLabel.text = "\(location.city!), \(location.country!)"
    }

}
