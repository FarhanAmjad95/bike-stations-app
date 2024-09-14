//
//  TestConstants.swift
//  BikeStationsAppTests
//
//  Created by Farhan Amjad on 14.09.24.
//

@testable import BikeStationsApp
import CoreLocation
import Foundation

enum TestConstants {
    enum BikeStations {
        static let station1 = BikeStation(id: "1", name: "Station 1", emptySlots: 5, freeBikes: 5, latitude: 48.215, longitude: 16.370)
        static let station2 = BikeStation(id: "2", name: "Station 2", emptySlots: 5, freeBikes: 5, latitude: 48.200, longitude: 16.360)
        static let station3 = BikeStation(id: "3", name: "Station 3", emptySlots: 5, freeBikes: 5, latitude: 48.210, longitude: 16.365)
        static let alphaStation = BikeStation(id: "1", name: "Alpha Station", emptySlots: 5, freeBikes: 5, latitude: 48.215, longitude: 16.370)
        static let betaStation = BikeStation(id: "2", name: "Beta Station", emptySlots: 5, freeBikes: 5, latitude: 48.200, longitude: 16.360)
        static let gammaStation = BikeStation(id: "3", name: "Gamma Station", emptySlots: 5, freeBikes: 5, latitude: 48.210, longitude: 16.365)
    }

    enum Locations {
        static let userLocation = CLLocation(latitude: 48.205, longitude: 16.365)
    }

    enum ErrorMessages {
        static let fetchBikeStationsError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch bike stations"])
    }

    enum Expectations {
        static let timeout: TimeInterval = 5.0
    }

    enum SortedNames {
        static let alphabetical = ["Alpha Station", "Beta Station", "Gamma Station"]
        static let distance = ["Station 3", "Station 2", "Station 1"]
    }
}
