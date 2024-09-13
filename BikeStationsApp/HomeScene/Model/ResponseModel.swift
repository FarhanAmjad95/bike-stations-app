//
//  Response.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import CoreLocation

// Codable Models
struct NetworkResponse: Decodable {
    let response: ResponseModel
    
    enum CodingKeys: String, CodingKey {
        case response =  "network"
    }
}

struct ResponseModel: Decodable {
    let stations: [BikeStation]
}

struct BikeStation: Identifiable, Decodable {
    let id: String
    let name: String
    let emptySlots: Int?
    let freeBikes: Int?
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case emptySlots = "empty_slots"
        case freeBikes = "free_bikes"
        case latitude
        case longitude
    }
}
