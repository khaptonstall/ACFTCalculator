import XCTest
@testable import ACFTCalculator

final class ACFTCalculatorTests: XCTestCase {

    // MARK: Tests

    func testInitDoesNotThrow() {
        XCTAssertNoThrow(try ACFTCalculator())
    }

    // MARK: Deadlift Calculator Tests

    func testCalculatingPointsForListedPoundsValueReturnsCorrectPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is explicitly listed on the CSV.
        // 140 pounds should equate to 60 points.
        let pounds = 140
        XCTAssertTrue(calculator.deadliftPounds.map { $0.value }.contains(pounds))

        let points = calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds))
        XCTAssertEqual(points, 60)
    }

    func testCalculatingPointsForUnlistedPoundsValueReturnsPointsForNextSmallestPoundsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is not explicitly listed on the CSV.
        // 140 pounds equates to 60 points, and the next value is 130 which
        // equates to 50 points. A value of 139 should also equate to 50 points.
        let pounds = 139
        XCTAssertFalse(calculator.deadliftPounds.map { $0.value }.contains(pounds))

        let points = calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds))
        XCTAssertEqual(points, 50)
    }

    func testCalculatingPointsForPoundsValueLessThanMinimumValueReturnsZeroPoints() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is less than the minimum pounds value (80 pounds).
        let pounds = 0
        let lastPoundsValue = try XCTUnwrap(calculator.deadliftPounds.last?.value)
        let minimumPoundsValue = try XCTUnwrap(lastPoundsValue)
        XCTAssertLessThan(pounds, minimumPoundsValue)

        // Verify a points value of 0 is returned.
        XCTAssertEqual(calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds)), 0)
    }

    // MARK: Sprint Drag Carry Calculator Tests

    func testCalculatingSprintDragCarryPointsForListedTimeValueReturnsCorrectPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is explicitly listed on the CSV.
        // 3:00 minutes should equate to 60 points.
        let time = RecordedTime(minutes: 3, seconds: 0)
        XCTAssertTrue(calculator.sprintDragCarryTimes.map { $0.value }.contains(time))

        let points = calculator.calculatePoints(for: .sprintDragCarry(time: time))
        XCTAssertEqual(points, 60)
    }

    func testCalculatingSprintDragCarryPointsForTimeValueFasterThanFastestListedTimeReturnsHighestPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is faster than the fasted listed time.
        // 1:33 is the fastest value, so use one that is faster than that.
        let time = RecordedTime(minutes: 0, seconds: 30)
        let fastestTimeValue = try XCTUnwrap(calculator.sprintDragCarryTimes.last?.value)
        XCTAssertLessThan(time, fastestTimeValue)

        let points = calculator.calculatePoints(for: .sprintDragCarry(time: time))
        XCTAssertEqual(points, 100)
    }

    func testCalculatingSprintDragCarryPointsForTimeValueSlowerThanSlowestListedTimeValueReturnsZeroPoints() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is slower than the slowest listed time.
        // 3:35 is the slowest value, so use one that is slower than that.
        let time = RecordedTime(minutes: 10, seconds: 0)
        let slowestTimeValue = try XCTUnwrap(calculator.sprintDragCarryTimes.last?.value)
        XCTAssertGreaterThan(time, slowestTimeValue)

        let points = calculator.calculatePoints(for: .sprintDragCarry(time: time))
        XCTAssertEqual(points, 0)
    }
}
