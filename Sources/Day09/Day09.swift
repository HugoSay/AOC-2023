//
//  Day09.swift
//  AoC-Swift-Template
//  Forked from https://github.com/Dean151/AoC-Swift-Template
//
//  Created by Thomas DURAND.
//  Follow me on Twitter @deanatoire
//  Check my computing blog on https://www.thomasdurand.fr/
//

import Foundation
// 1939607039
// 1939607041

import AoC
import Common
import Algorithms

func nextLine(for history: [Int]) -> [Int] {
    history.adjacentPairs()
        .map { $1 - $0 }
}

func buildDataSet(for history: [Int]) -> [[Int]] {
    var acc: [[Int]] = [history]
    while !acc.last!.allSatisfy({ $0 == 0 }) {
        acc.append(nextLine(for: acc.last!))
    }
    return acc
}

func interpolateNextValue(for dataSet: [[Int]]) -> Int {
    dataSet.reversed().reduce(0) { current, previousLine in
        assert(!previousLine.isEmpty, "should not be empty !")
        return previousLine.last.unsafelyUnwrapped + current
    }
}

func solveDay1(line: [Int]) -> Int {
    let dataset = buildDataSet(for: line)
    return interpolateNextValue(
        for: dataset
    )
}


let raw = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"""

let raw2 = "12 15 30 67 130 208 262 208 -104 -915 -2586 -5631 -10754 -18890 -31250 -49370 -75164 -110981 -159666 -224625 -309894"

let raw3 = "12 15 30 67 130 208 262 208 -104 -915 -2586 -5631 -10754 -18890 -31250 -49370 -75164 -110981 -159666 -224625 -309894 -420212"

@main
struct Day09: Puzzle {
    typealias Input = [[Int]]
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension [[Int]]: Parsable {
    public static func parse(raw: String) throws -> Array<[Int]> {
        raw.components(separatedBy: .newlines)
            .map { $0.components(separatedBy: .whitespaces).compactMap(Int.init) }
    }

    func printDebug() {
        var `self` = self
        self[0].append(interpolateNextValue(for: self))
        print(
          self.map { line in
                line.map(\.description).joined(separator: " ")
            }
                .joined(separator: "\n")
        )
    }
}

extension Day09 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 114, fromRaw: raw)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input
            .map(solveDay1(line:))
            .reduce(0, +)
    }
}

// MARK: - PART 2

extension Day09 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 2, fromRaw: raw)
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        input.map {
            $0.reversed()
        }
        .map(solveDay1(line:))
        .reduce(0, +)
    }
}

