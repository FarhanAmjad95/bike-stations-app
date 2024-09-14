//
//  BikeStationModel.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation

struct BikeStationModel: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let bikesAvailable: Int
    let emptySlots: Int

    init(station: BikeStation) {
        name = station.name
        latitude = station.latitude
        longitude = station.longitude
        bikesAvailable = station.freeBikes ?? 0
        emptySlots = station.emptySlots ?? 0
    }
}
