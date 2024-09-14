//
//  BikeStationsView.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import SwiftUI
import CoreLocation
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
    //Happy Case
    BikeStationsView(viewModel: BikeStationsViewModel(store: AppStore(), locationService: MockLocationService(), networkService: MockNetworkService(result: .success([BikeStation(id: "1", name: "Station 1", emptySlots: 5, freeBikes: 5, latitude: 48.215, longitude: 16.370), BikeStation(id: "2", name: "Station 2", emptySlots: 5, freeBikes: 5, latitude: 48.200, longitude: 16.360)]))))
    
    
    //Error
    /*
     BikeStationsView(viewModel: BikeStationsViewModel(store: AppStore(), locationService: MockLocationService(), networkService: MockNetworkService(result: .failure(NSError(domain: "No data", code: 0, userInfo: nil)))))
     */
}

