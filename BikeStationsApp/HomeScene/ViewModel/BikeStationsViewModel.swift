//
//  ViewModel.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import Combine
import UIKit
import CoreLocation

class BikeStationsViewModel: BikeStationsViewModelProtocol {
    @Published var bikeStations: [BikeStationModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: ErrorType? = nil
    @Published var selectedSegment: Segment = .first
    
    private var cancellables: Set<AnyCancellable> = []
    private let store: any StoreProtocol
    private let locationService: LocationServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    init(store: any StoreProtocol, locationService: LocationServiceProtocol, networkService: NetworkServiceProtocol) {
        self.store = store
        self.locationService = locationService
        self.networkService = networkService
        bindToStoreState()
        bindSegmentSelection()
    }
}

// MARK: - Store State Binding
extension BikeStationsViewModel {
    /// Binds to the store to listen for state changes and update the view model accordingly
    private func bindToStoreState() {
        store.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStoreStateUpdate(state)
            }
            .store(in: &cancellables)
    }

    /// Handles updates from the store state
    private func handleStoreStateUpdate(_ state: AppState) {
        isLoading = state.isLoading
        errorMessage = state.errorMessage
        bikeStations = state.bikeStations.map { BikeStationModel(station: $0) }
    }
}

// MARK: - Segment Selection Handling
extension BikeStationsViewModel {
    /// Binds the selected segment to handle changes in segment selection
    private func bindSegmentSelection() {
        $selectedSegment
            .sink { [weak self] segment in
                self?.handleSegmentChange(segment)
            }
            .store(in: &cancellables)
    }
    
    /// Handles changes in the segment picker
    private func handleSegmentChange(_ newSegment: Segment) {
        switch newSegment {
        case .first:
            handleFirstSegmentSelected()
        case .second:
            handleSecondSegmentSelected()
        case .third:
            handleThirdSegmentSelected()
        }
    }
    
    /// Handles the first segment selection
    private func handleFirstSegmentSelected() {
        store.dispatch(.setUserLocation(nil))
        Task {
            await refreshStations()
        }
    }
    
    /// Handles the second segment selection
    private func handleSecondSegmentSelected() {
        let defaultLocation = CLLocation(
            latitude: Constants.Location.defaultLatitude,
            longitude: Constants.Location.defaultLongitude
        )
        store.dispatch(.setUserLocation(defaultLocation))
        Task {
            await refreshStations()
        }
    }
    
    /// Handles the third segment selection
    private func handleThirdSegmentSelected() {
        Task {
            await requestLocationPermissions()
        }
    }
}

// MARK: - Location Management
extension BikeStationsViewModel {
    /// Requests location permissions asynchronously
    func requestLocationPermissions() async {
        await requestLocation()
    }
    
    /// Requests the user's location
    private func requestLocation() async {
        store.dispatch(.setLoading(true))
        
        do {
            let location = try await locationService.requestLocation()
            store.dispatch(.setUserLocation(location))
        } catch {
            handleErrorFetchingLocation(error)
        }
        
        monitorLocationAuthorizationStatus()
        store.dispatch(.setLoading(false))
    }
    
    /// Monitors location authorization status and fetches stations if authorized
    private func monitorLocationAuthorizationStatus() {
        locationService.authorizationStatus
            .sink { [weak self] status in
                self?.handleAuthorizationStatusChange(status)
            }
            .store(in: &cancellables)
    }

    /// Handles changes in the location authorization status
    private func handleAuthorizationStatusChange(_ status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            Task { 
                await requestLocation()
                await fetchBikeStations()
            }
        } else {
            if selectedSegment == .third {
                store.dispatch(.setErrorMessage(.locationPermissionError))
            }
        }
    }
}

// MARK: - Bike Stations Management
extension BikeStationsViewModel {
    /// Fetches bike stations asynchronously
    func refreshStations() async {
        await fetchBikeStations()
    }

    /// Fetches bike stations from the network service
    private func fetchBikeStations() async {
        store.dispatch(.setLoading(true))
        
        do {
            let stations = try await networkService.fetchBikeStations()
            store.dispatch(.setStations(stations))
        } catch {
            handleErrorFetchingLocation(error)
        }
        
        store.dispatch(.setLoading(false))
    }
}

// MARK: - Error Handling
extension BikeStationsViewModel {
    /// Handles errors when fetching location or bike stations
    private func handleErrorFetchingLocation(_ error: Error) {
        store.dispatch(.setErrorMessage(.otherError(error)))
    }
}

// MARK: - Utility Methods
extension BikeStationsViewModel {
    /// Opens the location in Apple Maps for the selected bike station
    func openMap(for station: BikeStationModel) {
        if let url = URL(string: Constants.AppURLs.appleMapsBaseURL + "?ll=\(station.latitude),\(station.longitude)") {
            UIApplication.shared.open(url)
        }
    }

    /// Requests location access by directing the user to the settings app
    func requestLocationAccess() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}



