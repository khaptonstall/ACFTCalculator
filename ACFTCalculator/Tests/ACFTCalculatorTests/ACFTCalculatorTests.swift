import XCTest
@testable import ACFTCalculator

final class ACFTCalculatorTests: XCTestCase {

    // MARK: Tests

    func testInitDoesNotThrow() {
        XCTAssertNoThrow(try ACFTCalculator())
    }

    // MARK: Deadlift Calculator Tests

    func testCalculatingDeadliftPointsForListedPoundsValueReturnsCorrectPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is explicitly listed on the CSV.
        // 140 pounds should equate to 60 points.
        let pounds = 140
        XCTAssertTrue(calculator.deadliftPounds.map { $0.value }.contains(pounds))

        let points = calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds))
        XCTAssertEqual(points, 60)
    }

    func testCalculatingDeadliftPointsForUnlistedPoundsValueReturnsPointsForNextSmallestPoundsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is not explicitly listed on the CSV.
        // 140 pounds equates to 60 points, and the next value is 130 which
        // equates to 50 points. A value of 139 should also equate to 50 points.
        let pounds = 139
        XCTAssertFalse(calculator.deadliftPounds.map { $0.value }.contains(pounds))

        let points = calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds))
        XCTAssertEqual(points, 50)
    }

    func testCalculatingDeadliftPointsForPoundsValueLessThanMinimumValueReturnsZeroPoints() throws {
        let calculator = try ACFTCalculator()

        // Use a pounds value that is less than the minimum pounds value (80 pounds).
        let pounds = 0
        let lastPoundsValue = try XCTUnwrap(calculator.deadliftPounds.last?.value)
        let minimumPoundsValue = try XCTUnwrap(lastPoundsValue)
        XCTAssertLessThan(pounds, minimumPoundsValue)

        // Verify a points value of 0 is returned.
        XCTAssertEqual(calculator.calculatePoints(for: .threeRepetitionMaximumDeadlift(pounds: pounds)), 0)
    }

    // MARK: Hand Release Push Up Calculator Tests

    func testCalculatingHandReleasePushUpPointsForListedRepsValueReturnsCorrectPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a repetitions value that is explicitly listed on the CSV.
        // 10 reps should equate to 60 points.
        let repetitions = 10
        XCTAssertTrue(calculator.handReleasePushUpRepetitions.map { $0.value }.contains(repetitions))

        let points = calculator.calculatePoints(for: .handReleasePushUp(repetitions: repetitions))
        XCTAssertEqual(points, 60)
    }

    func testCalculatingHandReleasePushUpPointsForRepsValueHigherThanHighestListedRepsReturnsHighestPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a repetitions value that is higher than the highest listed value.
        // 60 reps is the highest value, so use one that is higher than that.
        let repetitions = 100
        let highestRepetitionsValue = try XCTUnwrap(calculator.handReleasePushUpRepetitions.first?.value)
        XCTAssertGreaterThan(repetitions, highestRepetitionsValue)

        let points = calculator.calculatePoints(for: .handReleasePushUp(repetitions: repetitions))
        XCTAssertEqual(points, 100)
    }

    func testCalculatingHandReleasePushUpPointsForRepsValueLowerThanLowestListedRepsValueReturnsZeroPoints() throws {
        let calculator = try ACFTCalculator()

        // Use a repetitions value that is lower than the lowest listed value.
        // 0 reps is the lowest value, so we'll use a negative value.
        let repetitions = -1
        let lowestRepetitionsValue = try XCTUnwrap(calculator.handReleasePushUpRepetitions.last?.value)
        XCTAssertLessThan(repetitions, lowestRepetitionsValue)

        let points = calculator.calculatePoints(for: .handReleasePushUp(repetitions: repetitions))
        XCTAssertEqual(points, 0)
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

    // MARK: Leg Tuck Calculator Tests

    func testCalculatingLegTuckPointsForListedRepsValueReturnsCorrectPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a repetitions value that is explicitly listed on the CSV.
        // 1 rep should equate to 60 points.
        let repetitions = 1
        XCTAssertTrue(calculator.legTuckRepetitions.map { $0.value }.contains(repetitions))

        let points = calculator.calculatePoints(for: .legTuck(repetitions: repetitions))
        XCTAssertEqual(points, 60)
    }

    func testCalculatingLegTuckPointsForRepsValueHigherThanHighestListedRepsReturnsHighestPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a repetitions value that is higher than the highest listed value.
        // 20 reps is the highest value, so use one that is higher than that.
        let repetitions = 30
        let highestRepetitionsValue = try XCTUnwrap(calculator.legTuckRepetitions.first?.value)
        XCTAssertGreaterThan(repetitions, highestRepetitionsValue)

        let points = calculator.calculatePoints(for: .legTuck(repetitions: repetitions))
        XCTAssertEqual(points, 100)
    }

    func testCalculatingLegTuckPointsForRepsValueLowerThanLowestListedRepsValueReturnsZeroPoints() throws {
        let calculator = try ACFTCalculator()

        // Use a repetitions value that is lower than the lowest listed value.
        // 0 reps is the lowest value, so we'll use a negative value.
        let repetitions = -1
        let lowestRepetitionsValue = try XCTUnwrap(calculator.legTuckRepetitions.last?.value)
        XCTAssertLessThan(repetitions, lowestRepetitionsValue)

        let points = calculator.calculatePoints(for: .legTuck(repetitions: repetitions))
        XCTAssertEqual(points, 0)
    }

    // MARK: Plank Calculator Tests

    func testCalculatingPlankPointsForListedTimeValueReturnsCorrectPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is explicitly listed on the CSV.
        // 2:09 minutes should equate to 60 points.
        let time = RecordedTime(minutes: 2, seconds: 9)
        XCTAssertTrue(calculator.plankTimes.map { $0.value }.contains(time))

        let points = calculator.calculatePoints(for: .plank(time: time))
        XCTAssertEqual(points, 60)
    }

    func testCalculatingPlankPointsForTimeValueLongerThanLongestListedTimeReturnsHighestPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is longer than the longest listed time.
        // 4:20 is the longest listed value, so use one that is longer than that.
        let time = RecordedTime(minutes: 5, seconds: 0)
        let longestTimeValue = try XCTUnwrap(calculator.plankTimes.first?.value)
        XCTAssertGreaterThan(time, longestTimeValue)

        let points = calculator.calculatePoints(for: .plank(time: time))
        XCTAssertEqual(points, 100)
    }

    func testCalculatingPlankPointsForTimeValueShorterThanShortestListedTimeValueReturnsZeroPoints() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is shorte than the shortest listed time.
        // 2:03 is the shortest listed value, so use one that is shorter than that.
        let time = RecordedTime(minutes: 1, seconds: 0)
        let shortestTimeValue = try XCTUnwrap(calculator.plankTimes.last?.value)
        XCTAssertLessThan(time, shortestTimeValue)

        let points = calculator.calculatePoints(for: .plank(time: time))
        XCTAssertEqual(points, 0)
    }

    // MARK: Two-Mile Run Calculator Tests

    func testCalculatingTwoMileRunPointsForListedTimeValueReturnsCorrectPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is explicitly listed on the CSV.
        // 21:00 minutes should equate to 60 points.
        let time = RecordedTime(minutes: 21, seconds: 0)
        XCTAssertTrue(calculator.twoMileRunTimes.map { $0.value }.contains(time))

        let points = calculator.calculatePoints(for: .twoMileRun(time: time))
        XCTAssertEqual(points, 60)
    }

    func testCalculatingTwoMileRunPointsForTimeValueFasterThanFastestListedTimeReturnsHighestPointsValue() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is faster than the fasted listed time.
        // 13:30 is the fastest value, so use one that is faster than that.
        let time = RecordedTime(minutes: 12, seconds: 30)
        let fastestTimeValue = try XCTUnwrap(calculator.twoMileRunTimes.first?.value)
        XCTAssertLessThan(time, fastestTimeValue)

        let points = calculator.calculatePoints(for: .twoMileRun(time: time))
        XCTAssertEqual(points, 100)
    }

    func testCalculatingTwoMileRunPointsForTimeValueSlowerThanSlowestListedTimeValueReturnsZeroPoints() throws {
        let calculator = try ACFTCalculator()

        // Use a time value that is slower than the slowest listed time.
        // 22:48 is the slowest value, so use one that is slower than that.
        let time = RecordedTime(minutes: 23, seconds: 0)
        let slowestTimeValue = try XCTUnwrap(calculator.twoMileRunTimes.last?.value)
        XCTAssertGreaterThan(time, slowestTimeValue)

        let points = calculator.calculatePoints(for: .twoMileRun(time: time))
        XCTAssertEqual(points, 0)
    }

}
