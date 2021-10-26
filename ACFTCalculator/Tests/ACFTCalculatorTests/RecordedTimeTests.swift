//
//  RecordedTimeTests.swift
//  
//
//  Created by Kyle Haptonstall on 10/26/21.
//

@testable import ACFTCalculator
import XCTest

final class RecordedTimeTests: XCTestCase {
    // MARK: Tests

    func testComparableConformance() {
        // Verify comparing times when minutes differ.
        XCTAssertLessThan(RecordedTime(minutes: 1, seconds: 30),
                          RecordedTime(minutes: 10, seconds: 30))

        // Verify comparing times when minutes are equal but seconds differ.
        XCTAssertLessThan(RecordedTime(minutes: 10, seconds: 29),
                          RecordedTime(minutes: 10, seconds: 30))

        // Verify comparing equal times.
        XCTAssertEqual(RecordedTime(minutes: 1, seconds: 30),
                       RecordedTime(minutes: 1, seconds: 30))
    }

}
