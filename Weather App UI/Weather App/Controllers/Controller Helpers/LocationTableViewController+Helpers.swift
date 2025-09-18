//
//  APIKeyHelper.swift
//  Weather App
//
//  Created by Andrew CP Markham on 15/1/22.
//

import UIKit

extension LocationsTableViewController {
    /*
     Provides utility to present an alert to the user so they can
     enter their Open Wether API Key.
    */

    // DEV NOTE: Could validate the key by making a API call in the future

    func willCheckForAPIKey() {
        /**
         Function to check and set the API Key for use of the Open Weather API
         */

        let defaults = UserDefaults.standard

        let previousAPIKey = apiKey

        alert = UIAlertController(
            title: "Open Weather",
            message: "Please enter API key for Open Weather",
            preferredStyle: .alert)

        // Text Input
        alert?.addTextField { (textField: UITextField) in
            textField.placeholder = previousAPIKey == nil ? "Enter API Key" : previousAPIKey
            textField.keyboardType = .default
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }

        // OK Action
        // sets the API Key in user defaults regardless of what is entered
        let okActionTitle = previousAPIKey == nil ? "OK" : "Replace"
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: { (_) in
            if self.alert?.textFields![0].text == "" {
                defaults.removeObject(forKey: PropertyKeys.openWeatherAPIKey)
                self.apiKey = nil
            } else {
                self.apiKey = self.alert?.textFields![0].text
                defaults.set(self.apiKey, forKey: PropertyKeys.openWeatherAPIKey)

            }
        })
        if previousAPIKey == nil {
            okAction.isEnabled = false
        }
        alert?.addAction(okAction)
        // Cancel Action
        alert?.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
        }))

        self.present(alert!, animated: true, completion: nil)
    }

    func test() -> String {
        return "ABC"
    }

    /*
     Used to activate/deactivate the default button of the alert
     when textfield has/hasn't got any data
    */
    @objc func alertTextFieldDidChange(_ sender: UITextField) {
        alert?.actions[0].isEnabled = sender.text!.count > 0
    }
}
