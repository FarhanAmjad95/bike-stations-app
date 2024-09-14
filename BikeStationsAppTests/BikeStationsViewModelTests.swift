//
//  BikeStationsViewModelTests.swift
//  BikeStationAppTests
//
//  Created by Farhan Amjad on 13.09.24.
//

@testable import BikeStationsApp
import Combine
import CoreLocation
import XCTest

class BikeStationsViewModelTests: XCTestCase {
    var mockStore: AppStore!
    var locationMock: MockLocationService!

    override func setUp() {
        super.setUp()
        mockStore = AppStore()
        locationMock = MockLocationService(mockAuthorizationStatus: .authorizedAlways)
    }

    func testFetchBikeStationsSuccess() async {
        let networkService = MockNetworkService(result: .success([TestConstants.BikeStations.station1, TestConstants.BikeStations.station2]))
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: networkService)

        let expectation = XCTestExpectation(description: "Refresh stations should complete")

        let cancellable = viewModel.$bikeStations.sink { stations in
            if stations.count == 2 {
                expectation.fulfill()
            }
        }

        await viewModel.refreshStations()

        await fulfillment(of: [expectation], timeout: TestConstants.Expectations.timeout)

        XCTAssertEqual(viewModel.bikeStations.count, 2)
        XCTAssertEqual(viewModel.bikeStations[0].name, "Station 1")
        XCTAssertEqual(viewModel.bikeStations[1].name, "Station 2")

        cancellable.cancel()
    }

    func testFetchBikeStationsFailure() async {
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: MockNetworkService(result: .failure(TestConstants.ErrorMessages.fetchBikeStationsError)))

        let expectation = XCTestExpectation(description: "Refresh stations should complete")

        let cancellable = viewModel.$errorMessage.sink { message in
            if message != nil {
                expectation.fulfill()
            }
        }

        await viewModel.refreshStations()

        await fulfillment(of: [expectation], timeout: TestConstants.Expectations.timeout)

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage?.message, "Failed to fetch bike stations")

        cancellable.cancel()
    }

    func testSortingAlphabetically() async {
        let networkService = MockNetworkService(result: .success([TestConstants.BikeStations.gammaStation, TestConstants.BikeStations.alphaStation, TestConstants.BikeStations.betaStation]))
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: networkService)

        locationMock.mockLocation = nil

        let expectation = XCTestExpectation(description: "Refresh stations should complete")

        let cancellable = viewModel.$bikeStations.sink { stations in
            if stations.count == 3 {
                expectation.fulfill()
            }
        }

        await viewModel.refreshStations()

        await fulfillment(of: [expectation], timeout: TestConstants.Expectations.timeout)

        let sortedNames = viewModel.bikeStations.map { $0.name }

        XCTAssertEqual(sortedNames, TestConstants.SortedNames.alphabetical)

        cancellable.cancel()
    }

    func testSortingByDistance() async {
        locationMock.mockLocation = TestConstants.Locations.userLocation
        let networkService = MockNetworkService(result: .success([TestConstants.BikeStations.station1, TestConstants.BikeStations.station2, TestConstants.BikeStations.station3]))
        let viewModel = BikeStationsViewModel(store: mockStore, locationService: locationMock, networkService: networkService)

        let expectation = XCTestExpectation(description: "Refresh stations should complete")

        let cancellable = viewModel.$bikeStations.sink { stations in
            if stations.count == 3 {
                expectation.fulfill()
            }
        }

        await viewModel.requestLocation()

        await fulfillment(of: [expectation], timeout: TestConstants.Expectations.timeout)

        let sortedNames = viewModel.bikeStations.map { $0.name }

        XCTAssertEqual(sortedNames, TestConstants.SortedNames.distance)

        cancellable.cancel()
    }
}
