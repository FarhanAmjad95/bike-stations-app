//
//  BikeStationRow.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import SwiftUI

struct BikeStationRow: View {
    let station: BikeStationModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(station.name)
                .font(.headline)
            Text(Constants.ContentView.bikes + ": \(station.bikesAvailable)")
                .font(.subheadline)
            Text( Constants.ContentView.emptySlots + ": \(station.emptySlots)")
                .font(.subheadline)
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
