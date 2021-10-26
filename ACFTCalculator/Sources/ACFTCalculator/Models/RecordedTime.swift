//
//  RecordedTime.swift
//  
//
//  Created by Kyle Haptonstall on 10/25/21.
//

import Foundation

public struct RecordedTime {
    public let minutes: Int
    public let seconds: Int
}

// MARK: - Comparable

extension RecordedTime: Comparable {

    public static func < (lhs: RecordedTime, rhs: RecordedTime) -> Bool {
        if lhs.minutes < rhs.minutes {
            return true
        } else if lhs.minutes == rhs.minutes && lhs.seconds < rhs.seconds {
            return true
        } else {
            return false
        }
    }

}

// MARK: - StringInitializable

extension RecordedTime: StringInitializable {
    init?(string: String) {
        let components = string.components(separatedBy: ":")
        guard
            components.count == 2,
            let firstComponent = components.first,
            let minutes = Int(firstComponent),
            let secondComponent = components.last,
            let seconds = Int(secondComponent) else {
            return nil
        }

        self.minutes = minutes
        self.seconds = seconds
    }
}
