import XCTest
@testable import ACFTCalculator

final class ACFTCalculatorTests: XCTestCase {

    // MARK: Tests

    func testInitDoesNotThrow() {
        XCTAssertNoThrow(try ACFTCalculator())
    }

    func testColumnsHaveEqualLengths() throws {
        let calculator = try ACFTCalculator()

        // Ensure each column that was read into an array has equal length.
        // Each column should have 101 items (matching 0-100 possible points per event).
        let expectedLength = 101

        XCTAssertEqual(calculator.points.count, expectedLength)
        XCTAssertEqual(calculator.deadliftPounds.count, expectedLength)
        XCTAssertEqual(calculator.standingPowerThrowMeters.count, expectedLength)
        XCTAssertEqual(calculator.handReleasePushUpRepetitions.count, expectedLength)
        XCTAssertEqual(calculator.sprintDragCarryTimes.count, expectedLength)
        XCTAssertEqual(calculator.legTuckRepetitions.count, expectedLength)
        XCTAssertEqual(calculator.plankTimes.count, expectedLength)
        XCTAssertEqual(calculator.twoMileRunTimes.count, expectedLength)

    }

}
