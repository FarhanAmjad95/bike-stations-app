//
//  AppActions.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import CoreLocation

enum AppAction {
    case setStations([BikeStation])
    case setLoading(Bool)
    case setErrorMessage(String?)
    case setUserLocation(CLLocation?)
    case sortStationsByDistance
}
