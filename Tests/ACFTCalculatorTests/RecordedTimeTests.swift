// Copyright © 2021 Kyle Haptonstall.

@testable import ACFTCalculator
import XCTest

final class RecordedTimeTests: XCTestCase {
    // MARK: Tests

    func testComparableConformance() throws {
        // Verify comparing times when minutes differ.
        XCTAssertLessThan(try XCTUnwrap(RecordedTime(minutes: 1, seconds: 30)),
                          try XCTUnwrap(RecordedTime(minutes: 10, seconds: 30)))

        // Verify comparing times when minutes are equal but seconds differ.
        XCTAssertLessThan(try XCTUnwrap(RecordedTime(minutes: 10, seconds: 29)),
                          try XCTUnwrap(RecordedTime(minutes: 10, seconds: 30)))

        // Verify comparing equal times.
        XCTAssertEqual(try XCTUnwrap(RecordedTime(minutes: 1, seconds: 30)),
                       try XCTUnwrap(RecordedTime(minutes: 1, seconds: 30)))
    }

    func testMinutesAndSecondsInitReturnsNilForInvalidSecondsValue() {
        // Verify passing a seconds value past 59 seconds will return nil.
        XCTAssertNil(RecordedTime(minutes: 1, seconds: 60))
    }

    func testSecondsInitCorrectlyCalculatesMinutesAndSeconds() {
        let zeroValue = RecordedTime(seconds: 0)
        XCTAssertEqual(zeroValue.minutes, 0)
        XCTAssertEqual(zeroValue.seconds, 0)

        let valueUnderAMinute = RecordedTime(seconds: 59)
        XCTAssertEqual(valueUnderAMinute.minutes, 0)
        XCTAssertEqual(valueUnderAMinute.seconds, 59)

        let valueWithoutSeconds = RecordedTime(seconds: 120)
        XCTAssertEqual(valueWithoutSeconds.minutes, 2)
        XCTAssertEqual(valueWithoutSeconds.seconds, 0)

        let valueWithSeconds = RecordedTime(seconds: 125)
        XCTAssertEqual(valueWithSeconds.minutes, 2)
        XCTAssertEqual(valueWithSeconds.seconds, 5)
    }
}
