//
//  WeatherApp.swift
//  Weather App
//
//  Created by Andrew CP Markham on 29/10/2025.
//

import SwiftUI

@main
struct WeatherApp: App {

    // This connects the old AppDelegate lifecycle to SwiftUI and can be removed when completed
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
