//
//  Day08Tests.swift
//  AoC-Swift-Template
//  Forked from https://github.com/Dean151/AoC-Swift-Template
//
//  Created by Thomas DURAND.
//  Follow me on Twitter @deanatoire
//  Check my computing blog on https://www.thomasdurand.fr/
//

import XCTest

import AoC
@testable import Day08

final class Day08Tests: XCTestCase {
    func testPartOne() async throws {
        do {
            try await Day08.testPartOne()
        } catch TestError.expectationFailed(message: let message) {
            XCTFail(message)
        }
    }

    func testPartTwo() async throws  {
        do {
            try await Day08.testPartTwo()
        } catch TestError.expectationFailed(message: let message) {
        }
    }
}
