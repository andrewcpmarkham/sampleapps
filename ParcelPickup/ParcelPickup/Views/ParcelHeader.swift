//
//  File.swift
//  ParcelPickup
//
//  Created by Andrew CP Markham on 31/7/20.
//  Copyright © 2020 Xercise Pro. All rights reserved.
//

//Reference: https://jayeshkawli.ghost.io/add-headers-and-footers-to-tableview-sections/

import UIKit

class ParcelHeader: UITableViewHeaderFooterView {

    var nameLabel = UILabel()
    var addressLabel = UILabel()
    var statusLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        //Horizontal Stack
        //let horizontalStack = UIStackView(frame: .zero)
        let horizontalStack = UIStackView()
        contentView.addSubview(horizontalStack)
        horizontalStack.axis = NSLayoutConstraint.Axis.horizontal
        horizontalStack.distribution  = UIStackView.Distribution.fill
        horizontalStack.alignment = UIStackView.Alignment.fill
        horizontalStack.spacing   = 5.0
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.backgroundColor = .green

        NSLayoutConstraint.activate([
                   
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 49.0),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45.0),
            horizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            horizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
                   
        ])
        
        //Labels
        horizontalStack.addSubview(nameLabel)
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
       
        horizontalStack.addSubview(addressLabel)
        addressLabel.textAlignment = .left
        addressLabel.font = UIFont.boldSystemFont(ofSize: addressLabel.font.pointSize)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.numberOfLines = 0
        
        horizontalStack.addSubview(statusLabel)
        statusLabel.textAlignment = .right
        statusLabel.font = UIFont.boldSystemFont(ofSize: statusLabel.font.pointSize)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
                   
            nameLabel.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor, constant: 0.0),
            nameLabel.widthAnchor.constraint(equalToConstant: 93.5),
            nameLabel.topAnchor.constraint(equalTo: horizontalStack.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: horizontalStack.bottomAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5.0),
            statusLabel.leadingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 5.0),
            statusLabel.widthAnchor.constraint(equalToConstant: 93.5),
            statusLabel.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor),
        ])
    }

    func updateLabels(name: String, address: String, status: String) {
        nameLabel.text = name
        addressLabel.text = address
        statusLabel.text = status
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
