import Foundation

public final class ACFTCalculator {

    public enum ACFTEvent {
        case threeRepetitionMaximumDeadlift(pounds: Int)
    }

    // MARK: Properties

    typealias Points = Int
    typealias Pounds = Int
    typealias PointsMapping<T: StringInitializable> = [(points: Points, value: T)]

    /// Represents the column of pounds used for the 3-repetition maximum deadlift event.
    let deadliftPounds: PointsMapping<Pounds>

    /// Represents the column of meters for the standing power throw event.
    let standingPowerThrowMeters: [String]

    /// Represents the column of repetitions for the hand release push up event.
    let handReleasePushUpRepetitions: [String]

    /// Represents the column of times for the sprint-drag-carry event.
    let sprintDragCarryTimes: [String]

    /// Represents the column of repetitions for the leg tuck event.
    let legTuckRepetitions: [String]

    /// Represents the column of times for the plank event.
    let plankTimes: [String]

    /// Represents the column of times for the two-mile run event.
    let twoMileRunTimes: [String]

    // MARK: Initialization

    /// Creates a new instance of a `ACFTCalculator`, throwing an error if any issues arise
    /// while reading the scoring standards CSV file.
    public init() throws {
        let csvReader = try CSVReader.acftScoringStandardsReader()

        self.deadliftPounds = try csvReader.readColumn(.deadlift)
            .compactMapACFTColumnToPointsMapping()

        self.standingPowerThrowMeters = try csvReader.readColumn(.standingPowerThrow)
        self.handReleasePushUpRepetitions = try csvReader.readColumn(.handReleasePushUp)
        self.sprintDragCarryTimes = try csvReader.readColumn(.sprintDragCarry)
        self.legTuckRepetitions = try csvReader.readColumn(.legTuck)
        self.plankTimes = try csvReader.readColumn(.plank)
        self.twoMileRunTimes = try csvReader.readColumn(.twoMileRun)
    }

    // MARK: Calculating Points

    /// Calculates points earned for a given event.
    /// - Parameter event: The `ACFTEvent` and data necessary to calculate points earned.
    public func calculatePoints(for event: ACFTEvent) -> Int {
        switch event {
        case .threeRepetitionMaximumDeadlift(let pounds):
            return self.calculatePointsForDeadlift(pounds: pounds)
        }
    }

    private func calculatePointsForDeadlift(pounds: Int) -> Int {
        for (points, value) in self.deadliftPounds {
            // Because not all possible pounds values are listed in the CSV, if the
            // given input is greater than or equal to the current value, returrn that value's
            // matching points.
            guard pounds >= value else {
                continue
            }

            return points
        }

        // For any value less than lowest possible pounds value, return 0 points.
        return 0
    }
}

// MARK: - CSV Column Mapping Utilities

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

extension Array where Element == String {

    /// Performs a compact mapping on an array of `String`s which represents a column of the ACFT Scoring Standards CSV.
    /// This method will toss out any empty string values, then convert the remaining values to the given `StringInitializable` type.
    /// - Throws: A `csvReadingFailure` error if the array (column) contains the incorrect number of values or if conversion of the string to the `StringInitializable` type fails.
    func compactMapACFTColumnToPointsMapping<T: StringInitializable>() throws -> ACFTCalculator.PointsMapping<T> {
        // The array (column) of data should contain 101 entries, corresponding to the possible range of points (100 to 0).
        guard self.count == 101 else {
            throw ACFTCalculatorError.csvReadingFailure(reason: .invalidData)
        }

        return try self
            .enumerated() // Enumerate so we can get the index and later turn it into a Points value.
            .compactMap { (index, value) in
                guard !value.isEmpty else {
                    return nil
                }

                guard let convertedValue = T(string: value) else {
                    throw ACFTCalculatorError.csvReadingFailure(reason: .invalidData)
                }

                // Possible points range from 100 to 0, and each column contains 101 values.
                // Because each column is sorted from highest points (100) value to lowest (0),
                // to calculate the points for the current value we can take it's index and
                // subtract it from 100 possible points.
                let points = 100 - index
                return (points, convertedValue)
            }
    }

}
