//
//  AppState.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import CoreLocation
import Foundation

struct AppState {
    var bikeStations: [BikeStation] = []
    var isLoading: Bool = false
    var errorMessage: ErrorType?
    var userLocation: CLLocation?
}
