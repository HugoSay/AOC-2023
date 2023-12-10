//
//  Day09Tests.swift
//  AoC-Swift-Template
//  Forked from https://github.com/Dean151/AoC-Swift-Template
//
//  Created by Thomas DURAND.
//  Follow me on Twitter @deanatoire
//  Check my computing blog on https://www.thomasdurand.fr/
//

import XCTest

import AoC
@testable import Day09

final class Day09Tests: XCTestCase {
    func testPartOne() async throws {
        do {
            try await Day09.testPartOne()
        } catch TestError.expectationFailed(message: let message) {
            XCTFail(message)
        }
    }

    func testPartTwo() async throws  {
        do {
            try await Day09.testPartTwo()
        } catch TestError.expectationFailed(message: let message) {
            XCTFail(message)
        }
    }

    func testNextLine() {
        XCTAssertEqual(nextLine(for: [0, 3, 6, 9, 12, 15]), [3, 3, 3, 3, 3])
        XCTAssertEqual(nextLine(for: [1, 3, 6, 10, 15, 21]), [2, 3, 4, 5, 6])
        XCTAssertEqual(nextLine(for: [10, 13, 16, 21, 30, 45]), [3, 3, 5, 9, 15])
        XCTAssertEqual(nextLine(for: [12, 15, 30, 67, 130, 208, 262, 208, -104, -915, -2586, -5631, -10754, -18890, -31250, -49370, -75164, -110981, -159666, -224625, -309894, -420212]), [3, 15, 37, 63, 78, 54, -54, -312, -811, -1671, -3045, -5123, -8136, -12360, -18120, -25794, -35817, -48685, -64959, -85269, -110318])
    }

    func testSolveDay1() {
        XCTAssertEqual(solveDay1(line: [0, 3, 6, 9, 12, 15]), 18)
        XCTAssertEqual(solveDay1(line: [1, 3, 6, 10, 15, 21]), 28)
        XCTAssertEqual(solveDay1(line: [10, 13, 16, 21, 30, 45]), 68)
        XCTAssertEqual(solveDay1(line: [12, 15, 30, 67, 130, 208, 262, 208, -104, -915, -2586, -5631, -10754, -18890, -31250, -49370, -75164, -110981, -159666, -224625, -309894, -420212]), -561098)  // Replace ??? with the expected result
    }
}
