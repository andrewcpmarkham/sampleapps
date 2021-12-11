//
//  AddLocationTableViewCell.swift
//  Weather App
//
//  Created by Andrew CP Markham on 1/12/21.
//

import UIKit

class AddLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateLocationCell(with location: Location, at index: Int){
        //Update  UI with weather request data and always perform as it is current weather
        self.locationLabel.text = "\(location.city!), \(location.country!)"
    }
}
