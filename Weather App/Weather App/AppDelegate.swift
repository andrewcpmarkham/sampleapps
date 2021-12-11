//
//  AppDelegate.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.
//

import UIKit
import CoreData
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //cache implementation for speedy loading of images
        let tempDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25000000, diskCapacity: 50000000, diskPath: tempDirectory)
        URLCache.shared = urlCache

        // Fetch weather once an hour in background.
        if #available(iOS 13, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: PropertyKeys.backgroundRefreshID, using: nil) { task in

                self.handleWeatherRefreshTask(task: task as! BGAppRefreshTask)
            }
        }

        return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

//    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("App did enter background")
//        if #available(iOS 13, *) {
//            self.scheduleBackgroundProcessing()
//        }
//    }

    // MARK: - Core Data stack
    lazy var dataController = DataController()

    // FUNCTIONS
    func handleWeatherRefreshTask(task: BGAppRefreshTask) {
        //Cancel operation on timeout
        task.expirationHandler = {
            LocationCollection.shared.willCancelUpdateWeatherForLocations()
        }

        //Operation to update weather
        LocationCollection.shared.willUpdateWeatherForLocations()

        scheduleBackgroundWeatherFetch()
    }

    func scheduleBackgroundWeatherFetch() {
        let weatherFetchTask = BGAppRefreshTaskRequest(identifier: PropertyKeys.backgroundRefreshID)
        weatherFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
          try BGTaskScheduler.shared.submit(weatherFetchTask)
        } catch {
          print("Unable to submit task: \(error.localizedDescription)")
        }
    }


}

