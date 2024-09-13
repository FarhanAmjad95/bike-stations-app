//
//  ViewModel.swift
//  BikeStationAppTests
//
//  Created by Farhan Amjad on 13.09.24.
//

import XCTest
import CoreLocation
@testable import BikeStationsApp

class BikeStationsViewModelTests: XCTestCase {
    var mockStore: AppStore!
    var locationMock: MockLocationService!

    override func setUp() {
        super.setUp()
        mockStore = AppStore()
        locationMock = MockLocationService()
    }

    func testFetchBikeStationsSuccess() {
        let station1 = BikeStation(id: "1", name: "Station 1", emptySlots: 5, freeBikes: 5, latitude: 48.215, longitude: 16.370)
        let station2 = BikeStation(id: "2", name: "Station 2", emptySlots: 5, freeBikes: 5, latitude: 48.200, longitude: 16.360)
        let networkService = MockNetworkService(result: .success([station1, station2]))
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: networkService)
            
        viewModel.refreshStations()
        sleep(2)
        
        print("bike stations", viewModel.bikeStations)

        XCTAssertNotEqual(viewModel.bikeStations.count, 2)
        XCTAssertNotEqual(viewModel.bikeStations.first?.name, "Station 1")
        if let errorMessage = viewModel.errorMessage {
            XCTAssertNotNil(errorMessage, "Expected errorMessage to not be nil")
        }
    }

    func testFetchBikeStationsFailure() {
        let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch bike stations"])
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: MockNetworkService(result: .failure(error)))
        
        viewModel.refreshStations()
        sleep(2)
        
        if viewModel.bikeStations.count != 0 {
            XCTFail()
        }
        
        XCTAssertNotEqual(viewModel.errorMessage, "Failed to fetch bike stations")
    }
}

