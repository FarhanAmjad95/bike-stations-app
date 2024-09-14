//
//  ViewModelProtocol.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 14.09.24.
//

import Foundation

protocol BikeStationsViewModelProtocol: ObservableObject {
    var bikeStations: [BikeStationModel] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var selectedSegment: Segment { get set }

    
    func refreshStations() async
    func requestLocationPermissions() async
    func openMap(for station: BikeStationModel)
    func requestLocationAccess()
}
