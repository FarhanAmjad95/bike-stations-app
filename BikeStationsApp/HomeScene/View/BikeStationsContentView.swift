//
//  File.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 14.09.24.
//

import SwiftUI

struct BikeStationsContentView: View {
    var isLoading: Bool
    var errorMessage: String?
    var selectedSegment: Segment
    var bikeStations: [BikeStationModel]
    var requestLocationAccess: () -> Void
    var requestLocationPermissions: () -> Void
    var openMap: (BikeStationModel) -> Void
    
    var body: some View {
        if let errorMessage = errorMessage, selectedSegment == .third {
            errorView(errorMessage)
        } else if bikeStations.isEmpty {
            noStationsView
        } else {
            stationsListView
        }
    }
    
    private func errorView(_ errorMessage: String) -> some View {
        VStack {
            ErrorView(errorMessage: errorMessage)
            Button(Constants.Messages.grantLocationAccess) {
                requestLocationAccess()
            }
        }
    }
    
    private var noStationsView: some View {
        VStack {
            Text(Constants.Messages.nobikeAvailable)
                .font(.headline)
                .padding()
            Button(Constants.Messages.grantLocationAccess) {
                requestLocationPermissions()
            }
            .padding()
            .foregroundColor(.blue)
        }
    }
    
    private var stationsListView: some View {
        List(bikeStations) { station in
            BikeStationRow(station: station) {
                openMap(station)
            }
        }
    }
}
