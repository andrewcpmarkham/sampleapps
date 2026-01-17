//
//  WeatherUpdater.swift
//  Weather Sat
//
//  Created by Andrew CP Markham on 6/1/2026.
//

import Foundation
import SwiftUI

/// Protocol to ensure VMS  are capable of updating weather data from API
protocol WeatherUpdater {
    var location: Location { get set }

    func getLocationWeather() async
    func handleScenePhaseChange(_ phase: ScenePhase) async
}

extension WeatherUpdater {
    ///  Used to replace data if stale  when apps scene changes eg. becomes active from background
    /// - Parameter phase: Scene phase state that triggered chnage
    func handleScenePhaseChange(_ phase: ScenePhase) async {
        guard phase == .active else { return }
        if location.getDataDate() < Calendar.current.startOfDay(for: Date()) {
            await getLocationWeather()
        }
    }
}

protocol WeatherIconUpdater: WeatherUpdater {
    var iconURL: URL? { get set }
    func UpdateIcon()
}

