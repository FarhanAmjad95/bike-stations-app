//
//  BikeStationAppApp.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import SwiftUI

@main
struct BikeStationAppApp: App {
    var body: some Scene {
        WindowGroup {
            let location = LocationService()
            let network = NetworkService()
            let store = AppStore()
            let viewModel = BikeStationsViewModel(store: store, locationService: location, networkService: network)
            BikeStationsView(viewModel: viewModel)
        }
    }
}
