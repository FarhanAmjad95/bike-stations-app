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

import Combine
import CoreLocation

class AppStore: StoreProtocol {
    // MARK: - Properties
    /// The current state of the app. This is published to notify subscribers of state changes.
    @Published private(set) var state = AppState()
    
    /// Publisher that provides updates on the state of the app.
    var statePublisher: AnyPublisher<AppState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    /// Set of cancellables to manage subscriptions to publishers.
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Dispatching Actions
    
    /// Handles actions dispatched to the store and updates the state accordingly.
    /// - Parameter action: The action to be processed.
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
    
    // MARK: - Private Methods
    
    /// Sorts the list of bike stations by their distance from the user's location.
    private func sortStationsByDistance() {
        // If user location is not available, sort stations alphabetically by name
        guard let location = state.userLocation else {
            state.bikeStations.sort(by: { $0.name < $1.name })
            return
        }
        
        // Sort the stations based on their distance from the user's location
        state.bikeStations.sort { station1, station2 in
            let loc1 = CLLocation(latitude: station1.latitude, longitude: station1.longitude)
            let loc2 = CLLocation(latitude: station2.latitude, longitude: station2.longitude)
            return loc1.distance(from: location) < loc2.distance(from: location)
        }
    }
}

