// Copyright © 2021 Kyle Haptonstall.

import Foundation

extension CSVReader {
    /// Represents each column found in the `ACFTScoringStandards.csv` file.
    enum ACFTScoringStandardsColumn: Int {
        case points
        case deadlift
        case standingPowerThrow
        case handReleasePushUp
        case sprintDragCarry
        case legTuck
        case plank
        case twoMileRun
    }

    func readColumn(_ column: ACFTScoringStandardsColumn) throws -> [String] {
        return try self.readColumn(atIndex: column.rawValue, removeHeader: true)
    }

    /// Creates a `CSVReader` for the `ACFTScoringStandards.csv` file.
    static func acftScoringStandardsReader() throws -> CSVReader {
        return try CSVReader(csvFileName: "ACFTScoringStandards")
    }
}
