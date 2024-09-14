//
//  File.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 14.09.24.
//

import SwiftUI

struct LoadingView: View {
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            ProgressView(Constants.BikeStationsView.loadingMessage)
                .progressViewStyle(CircularProgressViewStyle())
                .padding(50)
                .background(Color.white)
                .cornerRadius(10)
        }
    }
}
