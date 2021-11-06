// Copyright © 2021 Kyle Haptonstall.

import Foundation

/// A type which can be initialized via a `String`.
protocol StringInitializable {
    init?(string: String)
}

// MARK: - Int + StringInitializable

extension Int: StringInitializable {
    init?(string: String) {
        guard let int = Int(string) else {
            return nil
        }
        self = int
    }
}

// MARK: - Float + StringInitializable

extension Float: StringInitializable {
    init?(string: String) {
        guard let float = Float(string) else {
            return nil
        }
        self = float
    }
}
