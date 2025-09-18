//
//  SceneDelegate.swift
//  Weather App
//
//  Created by Andrew CP Markham on 11/6/21.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Hijack the inital ViewController if a Favorite is set
        // This logic then traspors the user to the favoourite forecast
        // for the chosen location.
        // The back button is set for direct return to the lcocations screen

        if let favouriteLocation = FavouriteController.shared.getFavouriteLocation() {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let window = UIWindow(windowScene: windowScene)
            var favouriteViewController: FavoriteWeattherViewContoller?

            // Set the encompassing navigation controller and hence removing
            // forecasts out of the sequesnce
            guard let navViewController = storyboard.instantiateViewController(
                withIdentifier: PropertyKeys.defaultStoryBoardIdentifier) as? UINavigationController else {
                    fatalError("Navigation View Controller for favourite couldn't be set!")
                }

            switch FavouriteController.shared.getFavouriteForecast() {
            case .current:
                let currentWeatherViewController = storyboard.instantiateViewController(
                    withIdentifier: PropertyKeys.currentWeatherStoryboardId) as? CurrentWeatherViewController
                favouriteViewController = currentWeatherViewController

            case .hourly:
                let dayWeatherViewController = storyboard.instantiateViewController(
                    withIdentifier: PropertyKeys.dayWeatherStoryboardId) as? DayWeatherViewController
                favouriteViewController = dayWeatherViewController

            case .daily:
                let weekWeatherTableViewController = storyboard.instantiateViewController(
                    withIdentifier: PropertyKeys.weekWeatherStoryboardId) as? WeekWeatherTableViewController
                favouriteViewController = weekWeatherTableViewController

            case .none:
                // swiftlint:disable:next line_length
                fatalError("An unexpected error occured: a favourite should always have a forecast set. This one didn't")
            }

            guard let favouriteViewControllerUnwrapped = favouriteViewController else {
                fatalError("A favouite View Controller couldn't be established when a favourite exists")
            }
            favouriteViewControllerUnwrapped.willSetDataForFavourite(with: favouriteLocation, favouriteSeque: true)
            navViewController.pushViewController(favouriteViewControllerUnwrapped, animated: true)
            window.rootViewController = navViewController
            window.makeKeyAndVisible()
            self.window = window
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // swiftlint:disable:next force_cast
        (UIApplication.shared.delegate as! AppDelegate).scheduleBackgroundWeatherFetch()
    }
}
