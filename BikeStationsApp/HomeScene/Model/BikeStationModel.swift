//
//  File.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation

class BikeStationModel: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let bikesAvailable: Int
    let emptySlots: Int
    
    init(station: BikeStation) {
        self.name = station.name
        self.latitude = station.latitude
        self.longitude = station.longitude
        self.bikesAvailable = station.freeBikes ?? 0
        self.emptySlots = station.emptySlots ?? 0
    }
}
