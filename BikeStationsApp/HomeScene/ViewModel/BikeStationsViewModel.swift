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

class BikeStationsViewModel: ObservableObject {
    @Published var bikeStations: [BikeStationModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedSegment: Segment = .first
    
    private var cancellables: Set<AnyCancellable> = []
    private let store: any StoreProtocol
    private let locationService: LocationServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    init(store: any StoreProtocol, locationService: LocationServiceProtocol, networkService: NetworkServiceProtocol) {
        self.store = store
        self.locationService = locationService
        self.networkService = networkService
        
        // Listen for store state changes
        store.statePublisher
            .sink { [weak self] state in
                self?.isLoading = state.isLoading
                self?.errorMessage = state.errorMessage
                self?.bikeStations = state.bikeStations.map { BikeStationModel(station: $0) }
            }
            .store(in: &cancellables)
        
        $selectedSegment.sink { segment in
            self.handleSegmentChange(segment)
        }.store(in: &cancellables)
    }
    
    private func handleSegmentChange(_ newSegment: Segment) {
        // Implement your logic based on the new segment selection
        switch newSegment {
        case .first:
            store.dispatch(.setUserLocation(nil))
        case .second:
            store.dispatch(.setUserLocation(CLLocation(latitude: Constants.Location.defaultLatitude, longitude: Constants.Location.defaultLongitude)))
        case .third:
            requestLocationPermissions()
        }
    }
    
    func requestLocationPermissions() {
        requestLocation()
    }
    
    func refreshStations() {
        fetchBikeStations()
    }
    
    func requestLocationAccess() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    func openMap(for station: BikeStationModel) {
        if let url = URL(string: Constants.AppURLs.appleMapsBaseURL + "?ll=\(station.latitude),\(station.longitude)") {
            UIApplication.shared.open(url)
        }
    }
    
    func requestLocation() {
        self.store.dispatch(.setLoading(true))
        locationService.requestLocation { [weak self] result in
            DispatchQueue.main.async {
                self?.store.dispatch(.setLoading(false))
                switch result {
                case .success(let location):
                    self?.store.dispatch(.setUserLocation(location))
                case .failure(let error):
                    self?.store.dispatch(.setErrorMessage(Constants.Messages.errorFailedToFetchLocation + " " + ":\(error.localizedDescription)"))
                }
            }
        }
        
        
        locationService.authorizationStatus
            .sink { [weak self] status in
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self?.fetchBikeStations()
                } else {
                    self?.store.dispatch(.setErrorMessage(Constants.Messages.errorFailedToFetchLocation))
                }
            }
            .store(in: &cancellables)
    }

    private func fetchBikeStations() {
        self.store.dispatch(.setLoading(true))
        networkService.fetchBikeStations { [weak self] result in
            DispatchQueue.main.async {
                self?.store.dispatch(.setLoading(false))
                switch result {
                case .success(let stations):
                    self?.store.dispatch(.setStations(stations))
                case .failure(let error):
                    self?.store.dispatch(.setErrorMessage(Constants.Messages.errorFailedToFetchLocation + " " + ":\(error.localizedDescription)"))
                }
            }
        }
    }
}

