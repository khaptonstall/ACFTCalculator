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

    func testDeadliftValuesAreConvertableToInt() throws {
        let calculator = try ACFTCalculator()

        for value in calculator.deadliftPounds {
            // Skip over any empty strings.
            guard !value.isEmpty else {
                continue
            }
            // Verify any non-empty strings are convertable to Int.
            XCTAssertNotNil(Int(value))
        }
    }

    // MARK: Deadlift Calculator Tests

    func testCalculatingPointsForListedPoundsValueReturnsCorrectPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is explicitly listed on the CSV.
        // 140 pounds should equate to 60 points.
        let pounds = 140
        let points = calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds))
        XCTAssertEqual(points, 60)
    }

    func testCalculatingPointsForUnlistedPoundsValueReturnsPointsForNextSmallestPoundsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is not explicitly listed on the CSV.
        // 140 pounds equates to 60 points, and the next value is 130 which
        // equates to 50 points. A value of 139 should also equate to 50 points.
        let pounds = 139
        let points = calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds))
        XCTAssertEqual(points, 50)
    }

    func testCalculatingPointsForPoundsValueLessThanMinimumValueReturnsZeroPoints() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is less than the minimum pounds value (80 pounds).
        let pounds = 0
        let lastPoundsValue = try XCTUnwrap(calculator.deadliftPounds.last)
        let minimumPoundsValue = try XCTUnwrap(Int(lastPoundsValue))
        XCTAssertLessThan(pounds, minimumPoundsValue)

        // Verify a points value of 0 is returned.
        XCTAssertEqual(calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds)), 0)
    }

}
