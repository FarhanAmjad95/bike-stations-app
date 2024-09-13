//
//  File.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation
import CoreLocation

protocol NetworkServiceProtocol {
    func fetchBikeStations(completion: @escaping (Result<[BikeStation], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func fetchBikeStations(completion: @escaping (Result<[BikeStation], Error>) -> Void) {
        let url = URL(string: Constants.API.bikeStationsURL)!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(NetworkResponse.self, from: data)
                completion(.success(decodedResponse.network.stations))
                debugPrint(decodedResponse.network)
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
