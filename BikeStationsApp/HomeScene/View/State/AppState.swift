//
//  AppState.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import CoreLocation

struct AppState {
    var bikeStations: [BikeStation] = []
    var isLoading: Bool = false
    var errorMessage: ErrorType? = nil
    var userLocation: CLLocation? = nil
}
