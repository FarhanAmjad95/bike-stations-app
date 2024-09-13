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
    func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void)
}

class LocationService: NSObject, LocationServiceProtocol, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let authorizationStatusSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    
    // CLLocationManagerDelegate - Location updates
    private var locationCompletion: ((Result<CLLocation, Error>) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> {
        return authorizationStatusSubject.eraseToAnyPublisher()
    }
    
    func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        
        // Check if location services are enabled
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestLocation()
                self.locationCompletion = completion  // Store the completion closure
            } else {
                completion(.failure(LocationError.servicesDisabled))
            }
        }
    }
    
    // CLLocationManagerDelegate - Authorization changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatusSubject.send(status)
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    // Success: Did Update Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("print my current location", locations.first!)
        if let location = locations.first {
            locationCompletion?(.success(location))  // Return the location in success
        } else {
            locationCompletion?(.failure(LocationError.noLocationFound))
        }
        locationCompletion = nil  // Clear the stored completion
    }

    // Failure: Did Fail with Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(.failure(error))  // Pass the error to completion
        locationCompletion = nil  // Clear the stored completion
    }
    
    // MARK: - Custom Location Errors
    enum LocationError: Error {
        case servicesDisabled
        case noLocationFound
    }
}
