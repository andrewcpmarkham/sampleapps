//
//  AddLocationSearchTableViewCell.swift
//  Weather App
//
//  Created by Andrew CP Markham on 13/12/21.
//

import UIKit

class AddLocationSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameSearchBar: UISearchBar!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // SearchBar Setup
    func updateQuickSearchBar(addLocationTableViewController: AddLocationTableViewController) {

        nameSearchBar.delegate = addLocationTableViewController

        nameSearchBar.placeholder = "Search City..."

        // Hijack the clear 'X' of the search bar
        if let searchTextField = self.nameSearchBar.value(forKey: "searchField") as? UITextField,
           let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            clearButton.addTarget(
                addLocationTableViewController,
                action: #selector(addLocationTableViewController.searchBarXButtonClicked),
                for: .touchUpInside
            )
        }
    }

}
