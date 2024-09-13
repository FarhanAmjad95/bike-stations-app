//
//  AppStore.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import Combine
import CoreLocation


protocol StoreProtocol: ObservableObject {
    var state: AppState { get }
    var statePublisher: AnyPublisher<AppState, Never> { get }
    func dispatch(_ action: AppAction)
}

class AppStore: StoreProtocol {
    @Published private(set) var state = AppState()
    
    var statePublisher: AnyPublisher<AppState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable> = []
 
    func dispatch(_ action: AppAction) {
        switch action {
        case .setStations(let stations):
            state.errorMessage = nil
            state.bikeStations = stations
            dispatch(.sortStationsByDistance)
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setErrorMessage(let message):
            state.errorMessage = message
        case .setUserLocation(let location):
            state.userLocation = location
            dispatch(.sortStationsByDistance)
        case .sortStationsByDistance:
            sortStationsByDistance()
        }
    }
    
    private func sortStationsByDistance() {
        guard let location = state.userLocation else {
            state.bikeStations.sort(by: { $0.name < $1.name })
            return
        }
        
        state.bikeStations.sort(by: { station1, station2 in
            let loc1 = CLLocation(latitude: station1.latitude, longitude: station1.longitude)
            let loc2 = CLLocation(latitude: station2.latitude, longitude: station2.longitude)
            return loc1.distance(from: location) < loc2.distance(from: location)
        })
    }
}
