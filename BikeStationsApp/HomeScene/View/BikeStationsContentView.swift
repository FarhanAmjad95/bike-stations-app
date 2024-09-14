//
//  File.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 14.09.24.
//

import SwiftUI

struct BikeStationsContentView: View {
    // MARK: - Properties
    var isLoading: Bool
    var errorMessage: ErrorType?
    var selectedSegment: Segment
    var bikeStations: [BikeStationModel]
    var requestLocationAccess: () -> Void
    var requestLocationPermissions: () -> Void
    var openMap: (BikeStationModel) -> Void
    
    // MARK: - Body
    var body: some View {
        // Display content based on the current state
        if let errorMessage = errorMessage {
            errorView(errorMessage)
        } else if bikeStations.isEmpty {
            noStationsView
        } else {
            stationsListView
        }
    }
    
    // MARK: - Private Views

    /// View to show when there's an error
    private func errorView(_ errorType: ErrorType) -> some View {
        VStack {
            ErrorView(errorMessage: errorType.message)
            if errorType == .locationPermissionError {
                Button(Constants.Messages.grantLocationAccess) {
                    requestLocationAccess()
                }
                .padding()
            }
        }
    }

    /// View to show when there are no bike stations available
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
    
    /// View to display the list of bike stations
    private var stationsListView: some View {
        List(bikeStations) { station in
            BikeStationRow(station: station) {
                openMap(station)
            }
        }
    }
}
