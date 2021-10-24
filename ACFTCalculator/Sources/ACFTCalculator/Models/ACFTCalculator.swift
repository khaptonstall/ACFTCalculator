import Foundation

public final class ACFTCalculator {

    // MARK: Properties

    /// Represents the column of possible points one can receive for an ACFT event.
    let points: [String]

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
        self.points = try csvReader.readColumn(.points)
        self.deadliftPounds = try csvReader.readColumn(.deadlift)
        self.standingPowerThrowMeters = try csvReader.readColumn(.standingPowerThrow)
        self.handReleasePushUpRepetitions = try csvReader.readColumn(.handReleasePushUp)
        self.sprintDragCarryTimes = try csvReader.readColumn(.sprintDragCarry)
        self.legTuckRepetitions = try csvReader.readColumn(.legTuck)
        self.plankTimes = try csvReader.readColumn(.plank)
        self.twoMileRunTimes = try csvReader.readColumn(.twoMileRun)
    }
}

