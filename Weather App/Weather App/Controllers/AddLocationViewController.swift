//
//  AddLocationViewController.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var location: Location?
    var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false

        loadJSONCities()
    }
    
    func updateUI(location: Location?, error: Error?) {
        //Function to update UI appropriate to Location or Error supplied
        if let locationUnwrapped = location{
            self.location = locationUnwrapped
            self.titleTextLabel.text = "\(locationUnwrapped.city!), \(locationUnwrapped.country!)"
            self.descriptionTextLabel.text = "Longitude: \(locationUnwrapped.lon!), Latitude: \(locationUnwrapped.lat!)"
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
        //IMPLEMENT SEARCH ON CITY NAME HERE
    }

    func loadJSONCities(){
        guard let  path = Bundle.main.path(forResource: "city.list", ofType: "json"), let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            return
        }

        guard  let cities = try? JSONDecoder().decode([Location].self, from: json) else {
            return
        }

        locations = cities
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if let locationUnwrapped = self.location {
            LocationCollection.shared.addLocation(location: locationUnwrapped)
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
