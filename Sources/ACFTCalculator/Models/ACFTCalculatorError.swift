// Copyright © 2021 Kyle Haptonstall.

import Foundation

public enum ACFTCalculatorError: Error {
    // MARK: Errors

    /// An error that occurred while reading a CSV file or its contents.
    case csvReadingFailure(reason: CSVReadingFailureReason)
}

// MARK: - CSVReadingFailureReason

public extension ACFTCalculatorError {
    enum CSVReadingFailureReason {
        case fileNotFound(fileName: String)
        case columnOutOfBounds(index: Int)
        case invalidData
        case dataConversionFailed(type: Any.Type, value: Any)
    }
}
