//
//  StringInitializable.swift
//  
//
//  Created by Kyle Haptonstall on 10/25/21.
//

import Foundation

/// A type which can be initialized via a `String`.
protocol StringInitializable {
    init?(string: String)
}

extension Int: StringInitializable {
    init?(string: String) {
        guard let int = Int(string) else {
            return nil
        }
        self = int
    }
}
