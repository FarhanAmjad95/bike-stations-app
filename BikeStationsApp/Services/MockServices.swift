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
    
    func fetchBikeStations() async throws -> [BikeStation] {
        if let result = result {
            switch result {
            case .success(let stations):
                return stations
            case .failure(let error):
                throw error
            }
        } else {
            throw NSError(domain: "MockNetworkServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No result available"])
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
    func requestLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            if let mockLocation = mockLocation {
                continuation.resume(returning: mockLocation)
            } else if let mockError = mockError {
                continuation.resume(throwing: mockError)
            } else {
                // Provide a default location for testing
                let location = CLLocation(latitude: Constants.Location.defaultLatitude, longitude: Constants.Location.defaultLongitude)
                mockLocation = location
                continuation.resume(returning: location) // Vienna coordinates
            }
        }
    }
}

