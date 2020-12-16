//
//  AddLocationViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 30/9/20.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
    }
    
    func updateUI(location: Location?, error: Error?) {
        //Function to update UI appropriate to Location or Error supplied
        if let location = location{
            self.location = location
            self.titleTextLabel.text = "\(location.city!), \(location.country!)"
            self.descriptionTextLabel.text = "Longitude: \(location.lon!), Latitude: \(location.lat!)"
            self.titleTextLabel.isHidden = false
            self.descriptionTextLabel.isHidden = false
            saveButton.isEnabled = true
        }else if let error = error{
            self.titleTextLabel.text = "Error"
            self.descriptionTextLabel.text = "The following error occured: \(error)"
            self.titleTextLabel.isHidden = false
            self.descriptionTextLabel.isHidden = false
            saveButton.isEnabled = false
        }else{
            self.titleTextLabel.text = "Error"
            self.descriptionTextLabel.text = "An unknown error occured!"
            self.titleTextLabel.isHidden = false
            self.descriptionTextLabel.isHidden = false
            saveButton.isEnabled = false
        }
        
        
    }
    
    func fetchMatchingItems() {
        //Function to action search request to API based on search string supplied
        guard let searchTerm = searchBar.text else{return}
        let getLocationFromAPIDelegate = GetLocationFromAPIDelegate()
        
        getLocationFromAPIDelegate.fetchMatchingLocationsByName(with: searchTerm) { (location, error) in
            DispatchQueue.main.async {
                self.updateUI(location: location, error: error)
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let location = self.location {
            LocationCollection.shared.AddLocation(location: location)
        }
        performSegue(withIdentifier: PropertyKeys.saveLocationUnwindSegueIdentifier, sender: self)
    }
}

extension AddLocationViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Function for action of search triggered
        if let searchTerm = searchBar.text, !searchTerm.isEmpty {
            fetchMatchingItems()
        }else{
            self.titleTextLabel.text = ""
            self.descriptionTextLabel.text = ""
            self.titleTextLabel.isHidden = true
            self.descriptionTextLabel.isHidden = true
            saveButton.isEnabled = false
        }
        
        searchBar.resignFirstResponder()
    }
}
