//
//  ParcelCell.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 23/7/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

import UIKit

protocol ParcelCellDelegate: class {
    //Protocol to allow for quick check off as delivered
    func checkmarkTapped(sender: ParcelCell)
}

class ParcelCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var parcelNameLabel: UILabel!
    @IBOutlet weak var parcelAddressLabel: UILabel!
    @IBOutlet weak var parcelStatusLabel: UILabel!
    @IBOutlet weak var isDeliveredButton: UIButton!
    
    //Properties
    weak var delegate: ParcelCellDelegate?
    
    //Cell Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Functions
    func updateCell(with parcel: Parcel){
        parcelNameLabel.text = parcel.recipientName
        parcelAddressLabel.text = parcel.deliveryAddress
        parcelStatusLabel.text = parcel.status.description()
        if Status.isCompleted(status: parcel.status){
            //Udate image to checked if delivered
            isDeliveredButton.setImage(UIImage(systemName: PropertyKeys.imageCheckMark), for: .normal)
        }
    }
    
    //Actions
    @IBAction func deliveredButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }

}
