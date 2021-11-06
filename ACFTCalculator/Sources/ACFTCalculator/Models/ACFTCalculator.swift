// Copyright © 2021 Kyle Haptonstall.

import Foundation

public final class ACFTCalculator {
    public enum ACFTEvent {
        case threeRepetitionMaximumDeadlift(pounds: Int)
        case handReleasePushUp(repetitions: Int)
        case sprintDragCarry(time: RecordedTime)
        case legTuck(repetitions: Int)
        case plank(time: RecordedTime)
        case twoMileRun(time: RecordedTime)
    }

    // MARK: Properties

    typealias Points = Int
    typealias Pounds = Int
    typealias Repetitions = Int
    typealias PointsMapping<T: StringInitializable> = [(points: Points, value: T)]

    /// Represents the column of pounds used for the 3-repetition maximum deadlift event.
    let deadliftPounds: PointsMapping<Pounds>

    /// Represents the column of meters for the standing power throw event.
    let standingPowerThrowMeters: [String]

    /// Represents the column of repetitions for the hand release push up event.
    let handReleasePushUpRepetitions: PointsMapping<Repetitions>

    /// Represents the column of times for the sprint-drag-carry event.
    let sprintDragCarryTimes: PointsMapping<RecordedTime>

    /// Represents the column of repetitions for the leg tuck event.
    let legTuckRepetitions: PointsMapping<Repetitions>

    /// Represents the column of times for the plank event.
    let plankTimes: PointsMapping<RecordedTime>

    /// Represents the column of times for the two-mile run event.
    let twoMileRunTimes: PointsMapping<RecordedTime>

    // MARK: Initialization

    /// Creates a new instance of a `ACFTCalculator`, throwing an error if any issues arise
    /// while reading the scoring standards CSV file.
    public init() throws {
        let csvReader = try CSVReader.acftScoringStandardsReader()

        self.deadliftPounds = try csvReader.readColumn(.deadlift)
            .compactMapACFTColumnToPointsMapping()

        self.standingPowerThrowMeters = try csvReader.readColumn(.standingPowerThrow)

        self.handReleasePushUpRepetitions = try csvReader.readColumn(.handReleasePushUp)
            .compactMapACFTColumnToPointsMapping()

        self.sprintDragCarryTimes = try csvReader.readColumn(.sprintDragCarry)
            .compactMapACFTColumnToPointsMapping()

        self.legTuckRepetitions = try csvReader.readColumn(.legTuck)
            .compactMapACFTColumnToPointsMapping()

        self.plankTimes = try csvReader.readColumn(.plank)
            .compactMapACFTColumnToPointsMapping()

        self.twoMileRunTimes = try csvReader.readColumn(.twoMileRun)
            .compactMapACFTColumnToPointsMapping()
    }

    // MARK: Calculating Points

    private enum ColumnValueOrder {
        case ascending
        case descending
    }

    /// Calculates points earned for a given event.
    /// - Parameter event: The `ACFTEvent` and data necessary to calculate points earned.
    public func calculatePoints(for event: ACFTEvent) -> Int {
        switch event {
        case let .threeRepetitionMaximumDeadlift(pounds):
            return self.calculatePoints(forValue: pounds,
                                        pointsMapping: self.deadliftPounds,
                                        order: .descending)
        case let .handReleasePushUp(repetitions):
            return self.calculatePoints(forValue: repetitions,
                                        pointsMapping: self.handReleasePushUpRepetitions,
                                        order: .descending)
        case let .sprintDragCarry(time):
            return self.calculatePoints(forValue: time,
                                        pointsMapping: self.sprintDragCarryTimes,
                                        order: .ascending)
        case let .legTuck(repetitions):
            return self.calculatePoints(forValue: repetitions,
                                        pointsMapping: self.legTuckRepetitions,
                                        order: .descending)
        case let .plank(time):
            return self.calculatePoints(forValue: time,
                                        pointsMapping: self.plankTimes,
                                        order: .descending)
        case let .twoMileRun(time):
            return self.calculatePoints(forValue: time,
                                        pointsMapping: self.twoMileRunTimes,
                                        order: .ascending)
        }
    }

    /// Calculates the number of points earned in an individual ACFT event based on the input value and points mapping provided.
    /// - Parameters:
    ///   - inputValue: The user's input value for a given ACFT event (e.x. repetitions, recorded time).
    ///   - pointsMapping: A mapping of input values to possible awarded points.
    ///   - order: The order in which the CSV column values for the given points mapping are organized.
    /// - Returns: The number of points (0-100) the given input correlates to.
    private func calculatePoints<T: Comparable>(forValue inputValue: T,
                                                pointsMapping: PointsMapping<T>,
                                                order: ColumnValueOrder) -> Int {
        for (points, csvValue) in pointsMapping {
            switch order {
            case .ascending:
                if inputValue <= csvValue {
                    return points
                }
            case .descending:
                if inputValue >= csvValue {
                    return points
                }
            }

            continue
        }
        return 0
    }
}

// MARK: - CSV Column Mapping Utilities

private extension Array where Element == String {
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
            .compactMap { index, value in
                guard !value.isEmpty else {
                    return nil
                }

                guard let convertedValue = T(string: value) else {
                    throw ACFTCalculatorError.csvReadingFailure(reason: .dataConversionFailed(type: T.self, value: value))
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
