import Foundation

public final class ACFTCalculator {

    public enum ACFTEvent {
        case threeRepetitionMaximumDeadlift(pounds: Int)
    }

    // MARK: Properties

    /// Represents the column of possible points one can receive for an ACFT event.
    let points: [Int]

    /// Represents the column of pounds used for the 3-repetition maximum deadlift event.
    let deadliftPounds: [String]

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

    public init() throws {
        let csvReader = try CSVReader.acftScoringStandardsReader()

        self.points = try csvReader.readColumn(.points).map {
            guard let int = Int($0) else {
                throw ACFTCalculatorError.csvReadingFailure(reason: .pointsNotIntRepresentable(value: $0))
            }
            return int
        }

        self.deadliftPounds = try csvReader.readColumn(.deadlift)
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
        for (index, value) in self.deadliftPounds.enumerated() {
            // Skip over any empty strings.
            guard !value.isEmpty else {
                continue
            }

            // Because not all possible pounds values are listed in the CSV, if the
            // given input pounds value is greater than or equal to the current pounds
            // value, the input pounds value will fall under the current pounds point value.
            // Force-unwrapping as tests exist to validate CSV data is convertable to Int.
            guard pounds >= Int(value)! else {
                continue
            }

            return self.points[index]
        }

        // For any value less than lowest possible pounds value, return 0 points.
        return 0
    }
}
