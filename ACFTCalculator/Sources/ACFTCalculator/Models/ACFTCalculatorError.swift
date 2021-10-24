//
//  ACFTCalculatorError.swift
//  
//
//  Created by Kyle Haptonstall on 10/24/21.
//

import Foundation

enum ACFTCalculatorError: Error {
    // MARK: Errors

    /// An error that occurred while reading a CSV file or its contents.
    case csvReaderFailure(reason: CSVReadingFailureReason)

}

// MARK: - CSVReadingFailureReason

extension ACFTCalculatorError {

    enum CSVReadingFailureReason {
        case fileNotFound(fileName: String)
        case columnOutOfBounds(index: Int)
    }

}
