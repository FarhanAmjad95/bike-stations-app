//
//  File.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import CoreLocation

protocol NetworkServiceProtocol {
    func fetchBikeStations() async throws -> [BikeStation]
}

class NetworkService: NetworkServiceProtocol {
    func fetchBikeStations() async throws -> [BikeStation] {
        let url = URL(string: Constants.API.bikeStationsURL)!

        // Perform the network request asynchronously
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Optional: Check for HTTP errors
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: nil)
        }
        
        // Decode the JSON response
        do {
            let decodedResponse = try JSONDecoder().decode(NetworkResponse.self, from: data)
            debugPrint(decodedResponse.network)
            return decodedResponse.network.stations
        } catch {
            throw error // Rethrow decoding errors
        }
    }
}
