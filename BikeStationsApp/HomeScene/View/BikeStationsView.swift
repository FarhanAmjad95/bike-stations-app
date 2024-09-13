//
//  BikeStationsView.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import SwiftUI
import CoreLocation

struct BikeStationsView: View {
    @ObservedObject var viewModel: BikeStationsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // TODO: - Clean If else
                Picker(Constants.BikeStationsView.selectSegment, selection: $viewModel.selectedSegment) {
                    ForEach(Segment.allCases) { segment in
                        Text(segment.rawValue).tag(segment)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView(Constants.BikeStationsView.loadingMessage)
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let errorMessage = viewModel.errorMessage, viewModel.selectedSegment == .third {
                    VStack{
                        ErrorView(errorMessage: errorMessage)
                        Button(Constants.Messages.grantLocationAccess) {
                            viewModel.requestLocationAccess()
                        }
                    }
                } else if viewModel.bikeStations.isEmpty {
                    VStack {
                        Text(Constants.Messages.nobikeAvailable)
                            .font(.headline)
                            .padding()
                        Button(Constants.Messages.grantLocationAccess) {
                            viewModel.requestLocationPermissions()
                        }
                        .padding()
                        .foregroundColor(.blue)
                    }
                } else {
                    List(viewModel.bikeStations) { station in
                        BikeStationRow(station: station) {
                            viewModel.openMap(for: station)
                        }
                    }
                }
            }
            .navigationBarTitle(Constants.BikeStationsView.navigationTitle)
            .refreshable {
                viewModel.refreshStations()
            }
            .onAppear {
                viewModel.refreshStations()
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

