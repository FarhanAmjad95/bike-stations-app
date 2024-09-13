//
//  SegmentControl.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 13.09.24.
//

import Foundation

// Segment Control -- Home
enum Segment: String, CaseIterable, Identifiable {
    case first = "A-Z"
    case second = "Vienna"
    case third = "C Location"
    
    var id: Self { self }
}

