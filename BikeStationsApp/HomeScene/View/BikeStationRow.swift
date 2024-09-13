//
//  BikeStationRow.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import SwiftUI

struct BikeStationRow: View {
    let station: BikeStationModel
    let onViewMap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(station.name)
                    .font(.headline)
                Text(Constants.BikeStationsView.bikes + ": \(station.bikesAvailable)")
                    .font(.subheadline)
                Text( Constants.BikeStationsView.emptySlots + ": \(station.emptySlots)")
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

// Segment Control -- Home
enum Segment: String, CaseIterable, Identifiable {
    case first = "A-Z"
    case second = "Vienna"
    case third = "C Location"
    
    var id: Self { self }
}
