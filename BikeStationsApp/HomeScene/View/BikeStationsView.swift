//
//  BikeStationsView.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import CoreLocation
import SwiftUI

struct BikeStationsView: View {
    // MARK: - Properties

    @ObservedObject var viewModel: BikeStationsViewModel

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack {
                SegmentPickerView(selectedSegment: $viewModel.selectedSegment)

                Spacer()

                ZStack {
                    BikeStationsContentView(
                        isLoading: viewModel.isLoading,
                        errorMessage: viewModel.errorMessage,
                        selectedSegment: viewModel.selectedSegment,
                        bikeStations: viewModel.bikeStations,
                        requestLocationAccess: { viewModel.requestLocationAccess() },
                        requestLocationPermissions: {
                            Task {
                                await viewModel.requestLocation()
                            }
                        },
                        openMap: { station in
                            viewModel.openMap(for: station)
                        }
                    )

                    if viewModel.isLoading {
                        LoadingView()
                    }
                }
            }
            .navigationBarTitle(Constants.BikeStationsView.navigationTitle)
            .refreshable {
                Task {
                    await viewModel.refreshStations()
                }
            }
            .onAppear {
                Task {
                    await viewModel.refreshStations()
                }
            }
        }
    }
}

#Preview {
    BikeStationsView(
        viewModel: BikeStationsViewModel(
            store: Constants.MockConstants.appStore,
            locationService: Constants.MockConstants.mockLocationService,
            networkService: Constants.MockConstants.mockNetworkService
        )
    )
}
