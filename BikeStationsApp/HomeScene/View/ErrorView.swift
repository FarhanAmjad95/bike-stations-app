//
//  ErrorView.swift
//  BikeStationApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    
    var body: some View {
        VStack {
            Image(systemName: Constants.Images.exclamationMark) // Use an appropriate system image for errors
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.red)
                .frame(width: 100, height: 100)
            
            Text(errorMessage)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}
