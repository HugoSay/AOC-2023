//
//  Day06.swift
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
import Algorithms

let gameParser = Parse(input: Substring.self) {
    "Time:"; Whitespace(.horizontal)
    Many { Int.parser() } separator: { Whitespace(.horizontal) }
    Whitespace(.vertical)
    "Distance:"; Whitespace(.horizontal)
    Many { Int.parser() } separator: { Whitespace(.horizontal) }
}

struct Round {
    let time, distance: Int

    func distanceTraveleled(for timePressed: Int) -> Int {
        let remaining = time - timePressed
        return timePressed * remaining
    }

    var solved: Int {
        var count = 0
        for time in 1 ..< distance {
            if distanceTraveleled(for: time) > distance {
                count += 1
            }
        }
        return count
    }

    var smarterSolved: Int {
        let first = (0..<time).partitioningIndex { time in
            distanceTraveleled(for: time) > distance
        }

        let last = (first..<time).partitioningIndex { time in
            distanceTraveleled(for: time) < distance
        }

        return first.distance(to: last)
    }
}

struct Game: Parsable {
    let rounds: [Round]
    let part2Round: Round

    init(rounds: [Round]) {
        self.rounds = rounds
        let time = Int(rounds.map(\.time.description).joined())
        let distance = Int(rounds.map(\.distance.description).joined())
        part2Round = Round(time: time!, distance: distance!)
    }

    static func parse(raw: String) throws -> Game {
        let rounds = try gameParser
                .map(zip)
                .map{ zip in
                    zip.map(Round.init(time:distance:))
                }
            .parse(raw[...])

        return  Game(rounds: rounds )
    }
}

@main
struct Day06: Puzzle {
    typealias Input = Game
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension Day06 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 288, fromRaw: raw)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input.rounds.map(\.solved).reduce(1, *)
    }
}

// MARK: - PART 2

extension Day06 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 71503, fromRaw: raw)
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        input.part2Round.smarterSolved
    }
}

let raw = """
Time:      7  15   30
Distance:  9  40  200
"""
