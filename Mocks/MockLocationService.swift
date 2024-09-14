//
//  MockLocationService.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import CoreLocation
import Combine

class MockLocationService: LocationServiceProtocol {
    // Publisher for authorization status
    private let authorizationStatusSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    
    // Mock properties for testing
    var mockLocation: CLLocation?
    var mockError: Error?
    var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    init(mockLocation: CLLocation? = nil, mockError: Error? = nil, mockAuthorizationStatus: CLAuthorizationStatus) {
        self.mockLocation = mockLocation
        self.mockError = mockError
        self.mockAuthorizationStatus = mockAuthorizationStatus
    }
    
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


