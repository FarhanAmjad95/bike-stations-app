//
//  LocationService.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import CoreLocation
import Combine

protocol LocationServiceProtocol {
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> { get }
    func requestLocation() async throws -> CLLocation
    
}

class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private let authorizationStatusSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> {
        return authorizationStatusSubject.eraseToAnyPublisher()
    }
    
    func requestLocation() async throws -> CLLocation {
        locationManager.requestWhenInUseAuthorization()
        
        return try await withCheckedThrowingContinuation { continuation in
            guard CLLocationManager.locationServicesEnabled() else {
                continuation.resume(throwing: LocationError.servicesDisabled)
                return
            }
            
            self.locationContinuation = continuation
            locationManager.requestLocation()
        }
    }
    
    // MARK: - Custom Location Errors
    enum LocationError: Error {
        case servicesDisabled
        case noLocationFound
    }
}

extension LocationService : CLLocationManagerDelegate {
    // CLLocationManagerDelegate - Authorization changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusSubject.send(status)
    }
    
    // MARK: - CLLocationManagerDelegate

    // Success: Did Update Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationContinuation?.resume(returning: location)
        } else {
            locationContinuation?.resume(throwing: LocationError.noLocationFound)
        }
        locationContinuation = nil
    }

    // Failure: Did Fail with Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}

