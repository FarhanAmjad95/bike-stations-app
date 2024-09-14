//
//  ViewModel.swift
//  BikeStationAppTests
//
//  Created by Farhan Amjad on 13.09.24.
//

import XCTest
import CoreLocation
import Combine
@testable import BikeStationsApp


class BikeStationsViewModelTests: XCTestCase {
    var mockStore: AppStore!
    var locationMock: MockLocationService!

    override func setUp() {
        super.setUp()
        mockStore = AppStore()
        locationMock = MockLocationService()
    }

    func testFetchBikeStationsSuccess() async {
        let station1 = BikeStation(id: "1", name: "Station 1", emptySlots: 5, freeBikes: 5, latitude: 48.215, longitude: 16.370)
        let station2 = BikeStation(id: "2", name: "Station 2", emptySlots: 5, freeBikes: 5, latitude: 48.200, longitude: 16.360)
        let networkService = MockNetworkService(result: .success([station1, station2]))
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: networkService)

        let expectation = XCTestExpectation(description: "Refresh stations should complete")

        // Observe changes to the view model's bikeStations
        let cancellable = viewModel.$bikeStations.sink { stations in
            if stations.count == 2 {
                expectation.fulfill()
            }
        }

        await viewModel.refreshStations()

        // Await the fulfillment of the expectation
        await fulfillment(of: [expectation], timeout: 5.0)

        // Check if bike stations are correctly updated
        XCTAssertEqual(viewModel.bikeStations.count, 2)
        XCTAssertEqual(viewModel.bikeStations[0].name, "Station 1")
        XCTAssertEqual(viewModel.bikeStations[1].name, "Station 2")

        // Cancel the subscription
        cancellable.cancel()
    }

    func testFetchBikeStationsFailure() async {
        let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch bike stations"])
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: MockNetworkService(result: .failure(error)))

        let expectation = XCTestExpectation(description: "Refresh stations should complete")

        // Observe changes to the view model's errorMessage
        let cancellable = viewModel.$errorMessage.sink { message in
            if message != nil {
                expectation.fulfill()
            }
        }

        await viewModel.refreshStations()

        // Await the fulfillment of the expectation
        await fulfillment(of: [expectation], timeout: 5.0)

        // Check if error message is set
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage?.message, "Failed to fetch bike stations")

        // Cancel the subscription
        cancellable.cancel()
    }

    func testSortingAlphabetically() async {
        let station1 = BikeStation(id: "1", name: "Alpha Station", emptySlots: 5, freeBikes: 5, latitude: 48.215, longitude: 16.370)
        let station2 = BikeStation(id: "2", name: "Beta Station", emptySlots: 5, freeBikes: 5, latitude: 48.200, longitude: 16.360)
        let station3 = BikeStation(id: "3", name: "Gamma Station", emptySlots: 5, freeBikes: 5, latitude: 48.210, longitude: 16.365)

        let networkService = MockNetworkService(result: .success([station3, station1, station2]))
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: networkService)

        // Simulate no user location
        locationMock.mockLocation = nil

        let expectation = XCTestExpectation(description: "Refresh stations should complete")

        // Observe changes to the view model's bikeStations
        let cancellable = viewModel.$bikeStations.sink { stations in
            if stations.count == 3 {
                expectation.fulfill()
            }
        }

        await viewModel.refreshStations()

        // Await the fulfillment of the expectation
        await fulfillment(of: [expectation], timeout: 5.0)

        // Check if stations are sorted alphabetically
        let sortedNames = viewModel.bikeStations.map { $0.name }
        let expectedNames = ["Alpha Station", "Beta Station", "Gamma Station"]
        
        print("Sorted Names: \(sortedNames)")
        print("Expected Names: \(expectedNames)")

        XCTAssertEqual(sortedNames, expectedNames)

        // Cancel the subscription
        cancellable.cancel()
    }

    func testSortingByDistance() async {
        let station1 = BikeStation(id: "1", name: "Station 1", emptySlots: 5, freeBikes: 5, latitude: 48.215, longitude: 16.370)
        let station2 = BikeStation(id: "2", name: "Station 2", emptySlots: 5, freeBikes: 5, latitude: 48.200, longitude: 16.360)
        let station3 = BikeStation(id: "3", name: "Station 3", emptySlots: 5, freeBikes: 5, latitude: 48.210, longitude: 16.365)


        let userLocation = CLLocation(latitude: 48.205, longitude: 16.365)
        locationMock.mockLocation = userLocation

        let networkService = MockNetworkService(result: .success([station1, station2, station3]))
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: networkService)

        let expectation = XCTestExpectation(description: "Refresh stations should complete")

        // Observe changes to the view model's bikeStations
        let cancellable = viewModel.$bikeStations.sink { stations in
            if stations.count == 3 {
                expectation.fulfill()
            }
        }

        await viewModel.requestLocation()

        // Await the fulfillment of the expectation
        await fulfillment(of: [expectation], timeout: 5.0)

        // Check if stations are sorted by distance from user location
        let sortedNames = viewModel.bikeStations.map { $0.name }
        let expectedNames = ["Station 3", "Station 2", "Station 1"]

        print("Sorted by Distance Names: \(sortedNames)")
        print("Expected Distance Names: \(expectedNames)")

        XCTAssertEqual(sortedNames, expectedNames)

        // Cancel the subscription
        cancellable.cancel()
    }
}
