//
//  BikeStationRow.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import SwiftUI

struct BikeStationRow: View {
    // MARK: - Properties

    let station: BikeStationModel
    let onViewMap: () -> Void

    // MARK: - Body

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(station.name)
                    .font(.headline)
                Text(Constants.BikeStationsView.bikes + ": \(station.bikesAvailable)")
                    .font(.subheadline)
                Text(Constants.BikeStationsView.emptySlots + ": \(station.emptySlots)")
                    .font(.subheadline)
            }
            Spacer()
            Button(action: {
                onViewMap()
            }) {
                Text(Constants.BikeStationsView.viewOnMap)
                    .foregroundColor(.blue)
            }
        }
    }
}
