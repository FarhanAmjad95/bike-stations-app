//
//  ErrorType.swift
//  BikeStationsApp
//
//  Created by Farhan Amjad on 14.09.24.
//

import Foundation

// Enum to represent different types of errors
enum ErrorType : Equatable {
    case networkError
    case locationPermissionError
    case otherError(Error) // For any other types of errors

    var message: String {
        switch self {
        case .networkError:
            return "Network error occurred. Please check your connection."
        case .locationPermissionError:
            return Constants.Messages.errorFailedToFetchLocation
        case .otherError(let errorMessage):
            return errorMessage.localizedDescription
        }
    }
    
    static func == (lhs: ErrorType, rhs: ErrorType) -> Bool {
        return true
    }
}
