//
//  Mock.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import Combine
import CoreLocation

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<[BikeStation], Error>?
    
    init(result: Result<[BikeStation], Error>? = nil) {
        self.result = result
    }
    
    func fetchBikeStations(completion: @escaping (Result<[BikeStation], Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

class MockLocationService: LocationServiceProtocol {
    // Publisher for authorization status
    private let authorizationStatusSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    
    // Mock properties for testing
    var mockLocation: CLLocation?
    var mockError: Error?
    var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    var authorizationStatus: AnyPublisher<CLAuthorizationStatus, Never> {
        return authorizationStatusSubject.eraseToAnyPublisher()
    }
   
    // Simulates requesting the current location
    func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        // Simulate success or failure based on the mock properties
        if let mockLocation = mockLocation {
            completion(.success(mockLocation))
        } else if let mockError = mockError {
            completion(.failure(mockError))
        } else {
            // Provide a default location for testing
            let location = CLLocation(latitude: Constants.Location.defaultLatitude, longitude: Constants.Location.defaultLongitude)
            mockLocation = location
            completion(.success(location)) // Vienna coordinates
        }
    }
}
