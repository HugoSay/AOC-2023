//
//  Day13Tests.swift
//  AoC-Swift-Template
//  Forked from https://github.com/Dean151/AoC-Swift-Template
//
//  Created by Thomas DURAND.
//  Follow me on Twitter @deanatoire
//  Check my computing blog on https://www.thomasdurand.fr/
//

import XCTest

import AoC
@testable import Day13

final class Day13Tests: XCTestCase {

    func testReflexionValue() {
        XCTAssertEqual(Note.reflectionValue(for: [1,2,2,1]), 2)
        XCTAssertEqual(Note.reflectionValue(for: [2,1,2,2,1]), 3)
        XCTAssertEqual(Note.reflectionValue(for: [1,1,3,5,4,3]), 1)
        XCTAssertEqual(Note.reflectionValue(for: [1,2,2,1,5,4,3]), 2)
        XCTAssertEqual(Note.reflectionValue(for: [1,2,3,1,5,1,1]), 6)
    }

    func testPartOne() async throws {
        do {
            try await Day13.testPartOne()
        } catch TestError.expectationFailed(message: let message) {
            XCTFail(message)
        }
    }

    func testPartTwo() async throws  {
        do {
            try await Day13.testPartTwo()
        } catch TestError.expectationFailed(message: let message) {
            XCTFail(message)
        }
    }
}
