//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Andrew CP Markham on 24/12/21.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateLocationCell(for row: Int) {
        switch row {
        case 0:
            cellLabel.text = "Current Weather"
        case 1:
            cellLabel.text = "24-hour Forcast"
        case 2:
            cellLabel.text = "7-day Forcast"
        default:
            cellLabel.text = "Not Used"
        }
    }
}
