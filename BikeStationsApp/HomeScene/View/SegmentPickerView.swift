//
//  File.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 14.09.24.
//

import SwiftUI

struct SegmentPickerView: View {
    @Binding var selectedSegment: Segment
    
    var body: some View {
        Picker(Constants.BikeStationsView.selectSegment, selection: $selectedSegment) {
            ForEach(Segment.allCases) { segment in
                Text(segment.rawValue).tag(segment)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}
