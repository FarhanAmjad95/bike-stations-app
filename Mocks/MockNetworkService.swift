//
//  MockNetworkService.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<[BikeStation], Error>?

    init(result: Result<[BikeStation], Error>? = nil) {
        self.result = result
    }

    func fetchBikeStations() async throws -> [BikeStation] {
        if let result = result {
            switch result {
            case let .success(stations):
                return stations
            case let .failure(error):
                throw error
            }
        } else {
            throw NSError(domain: "MockNetworkServiceError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No result available"])
        }
    }
}
