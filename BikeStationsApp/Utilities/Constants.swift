//
//  Constants.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation

enum Constants {
    enum API {
        static let bikeStationsURL = "https://api.citybik.es/v2/networks/wienmobil-rad"
    }

    enum Location {
        static let defaultLatitude = 48.210033
        static let defaultLongitude = 16.363449
    }

    enum Messages {
        static let locationPermissionDenied = "Location permission is denied. Please enable it in settings."
        static let locationPermissionExplanation = "We need access to your location to show nearby bike stations."
        static let errorFailedToFetchLocation = "Failed to fetch location"
        static let grantLocationAccess = "Grant Location Access"
        static let nobikeAvailable = "No bike stations available."
    }

    enum AppURLs {
        static let appleMapsBaseURL = "http://maps.apple.com/"
    }

    enum BikeStationsView {
        static let navigationTitle = "Bike Stations"
        static let selectSegment = "Select a segment"
        static let viewOnMap = "View on Map"
        static let emptySlots = "Empty Slots"
        static let bikes = "Bikes"
        static let loadingMessage = "Loading..."
    }

    enum Images {
        static let exclamationMark = "exclamationmark.triangle"
    }

    enum MockConstants {
        static let mockBikeStations: [BikeStation] = [
            BikeStation(id: "1", name: "Station 1", emptySlots: 5, freeBikes: 5, latitude: 48.215, longitude: 16.370),
            BikeStation(id: "2", name: "Station 2", emptySlots: 5, freeBikes: 5, latitude: 48.200, longitude: 16.360),
        ]

        static let mockLocationService = MockLocationService(mockAuthorizationStatus: .denied)
        static let mockNetworkService = MockNetworkService(result: .success(mockBikeStations))
        static let appStore = AppStore()
    }
}
