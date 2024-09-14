//
//  SegmentPickerView.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 14.09.24.
//

import SwiftUI

struct SegmentPickerView: View {
    // MARK: - Properties

    @Binding var selectedSegment: Segment

    // MARK: - Body

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

// Segment Control -- Home
enum Segment: String, CaseIterable, Identifiable {
    case first = "A-Z"
    case second = "Vienna"
    case third = "C Location"

    var id: Self { self }
}
