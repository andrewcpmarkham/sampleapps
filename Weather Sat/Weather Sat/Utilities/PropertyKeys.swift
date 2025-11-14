//
//  PropertyKeys.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import Foundation

/**
 Central storage of magic keys ( iteral strings) refferenced throughout the app
*/
struct PropertyKeys {

}

extension UserDefaults {
    private enum Keys {
        static let previouslyLaunchedKey = "previouslyLaunchedKey"
    }

    var hasLaunchedBefore: Bool {
        get { bool(forKey: Keys.previouslyLaunchedKey) }
        set { set(newValue, forKey: Keys.previouslyLaunchedKey) }
    }
}
