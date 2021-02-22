//
//  PersonCell.swift
//  GenericsApp
//
//  Created by Andrew CP Markham on 22/2/21.
//

import UIKit

final class PersonCell: UITableViewCell {
    var person: Person? {
        didSet {
            if let person = person {
                nameLabel.text = person.name
                genderLabel.text = person.gender
            }
        }
    }
    
    private lazy var nameLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .darkGray
        v.font = v.font.withSize(16)
        return v
    }()
    
    private lazy var genderLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .secondaryLabel
        v.font = v.font.withSize(14)
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        [nameLabel, genderLabel].forEach { (v) in
            addSubview(v)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        //name label
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        
        //gender label
        NSLayoutConstraint.activate([
            genderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            genderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            genderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
