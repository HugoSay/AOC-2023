//
//  Day01.swift
//  AoC-Swift-Template
//  Forked from https://github.com/Dean151/AoC-Swift-Template
//
//  Created by Thomas DURAND.
//  Follow me on Twitter @deanatoire
//  Check my computing blog on https://www.thomasdurand.fr/
//

import Foundation
import Parsing
import AoC
import Common

@main
struct Day01: Puzzle {
    // TODO: Start by defining your input/output types :)
    typealias Input = String
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension Day01 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 12, fromRaw: "1abc2"),
            assert(expectation: 38, fromRaw: "pqr3stu8vwx"),
            assert(expectation: 15, fromRaw: "a1b2c3d4e5f"),
            assert(expectation: 77, fromRaw: "treb7uchet")
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input.components(separatedBy: .newlines)
            .map { line in
                let line = line.compactMap(\.wholeNumberValue)
                return line.first! * 10 + line.last!
            }
            .reduce(0, +)
    }

}

let writtenDigits = [
    "one": "one1one",
    "two": "two2two",
    "three": "three3three",
    "four": "four4four",
    "five": "five5five",
    "six": "six6six",
    "seven": "seven7seven",
    "eight": "eight8eight",
    "nine": "nine9nine"
]


extension Day01 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 29, from: "two1nine"),
            assert(expectation: 83, from: "eightwothree"),
            assert(expectation: 13, from: "abcone2threexyz"),
            assert(expectation: 24, from: "xtwone3four"),
            assert(expectation: 42, from: "4nineeightseven2"),
            assert(expectation: 14, from: "zoneight234"),
            assert(expectation: 76, from: "7pqrstsixteen")
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        var input = input

        writtenDigits.keys.forEach { key in
            input = input.replacingOccurrences(of: key, with: writtenDigits[key]!)
        }
        return try await solvePartOne(input)
    }
}
