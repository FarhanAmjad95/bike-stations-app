//
//  AppActions.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import CoreLocation
import Foundation

enum AppAction {
    case setStations([BikeStation])
    case setLoading(Bool)
    case setErrorMessage(ErrorType?)
    case setUserLocation(CLLocation?)
    case sortStationsByDistance
}
