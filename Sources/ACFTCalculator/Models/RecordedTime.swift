// Copyright © 2021 Kyle Haptonstall.

import Foundation

public struct RecordedTime {
    // MARK: Properties

    public let minutes: Int
    public let seconds: Int

    // MARK: Initialization

    /// Attempts creating a new instance of `RecordedTime`. Initialization will fail if the value for `seconds` is greater than 59.
    /// - Parameters:
    ///   - minutes: The number of minutes.
    ///   - seconds: The number of seconds. Must be between 0...59.
    public init?(minutes: UInt, seconds: UInt) {
        guard (0 ... 59).contains(seconds) else {
            return nil
        }
        self.minutes = Int(minutes)
        self.seconds = Int(seconds)
    }

    /// Creates a new instance of `RecordedTime` by converting the `seconds` into minutes and seconds.
    /// - Parameter seconds: The number of seconds.
    public init(seconds: UInt) {
        self.minutes = Int(seconds / 60)
        self.seconds = Int(seconds % 60)
    }
}

// MARK: - Comparable

extension RecordedTime: Comparable {
    public static func < (lhs: RecordedTime, rhs: RecordedTime) -> Bool {
        if lhs.minutes < rhs.minutes {
            return true
        } else if lhs.minutes == rhs.minutes, lhs.seconds < rhs.seconds {
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
            let minutes = UInt(firstComponent),
            let secondComponent = components.last,
            let seconds = UInt(secondComponent) else {
            return nil
        }

        self.init(minutes: minutes, seconds: seconds)
    }
}
