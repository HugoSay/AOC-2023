//
//  Day13.swift
//  AoC-Swift-Template
//  Forked from https://github.com/Dean151/AoC-Swift-Template
//
//  Created by Thomas DURAND.
//  Follow me on Twitter @deanatoire
//  Check my computing blog on https://www.thomasdurand.fr/
//

import Foundation

import AoC
import Common

public struct Note: Parsable {
    let lines: [String]
    let columns: [String]

    init(lines: [String], colunms: [String]) {
        self.lines = lines
        self.columns = colunms
    }

    public static func parse(raw: String) throws -> Note {
        let rawLines = raw.components(separatedBy: .newlines)
        var columns: [[Character]] = Array(repeating: Array(repeating: "X", count: rawLines.count), count: rawLines.first!.count)

        for (i, line) in rawLines.enumerated() {
            for (j, char) in line.enumerated() {
                columns[j][i] = char
            }
        }

        return Note(lines: rawLines, colunms: columns.map { String($0) })
    }

    var reflectionValue: Int {
        Self.reflectionValue(for: columns) + Self.reflectionValue(for: lines, multiplier: 100)
    }

    static func reflectionValue<T: Equatable>(for array: [T], multiplier: Int = 1) -> Int {
        for i in 1..<array.count {
            if array[i-1] == array[i] { // potentialMatch
                // find smaller half
                let lhs = array[..<i]
                let rhs = array[i...]
                if lhs.count > rhs.count {
                    if lhs.reversed().prefix(rhs.count) == rhs {
                        return lhs.count * multiplier
                    }
                } else {
                    if rhs.prefix(lhs.count) == lhs.reversed()[...] {
                        return lhs.count * multiplier
                    }
                }
            }
        }
        return 0
    }

}


struct Game: Parsable {
    let notes: [Note]
    public static func parse(raw: String) throws -> Game {
        let rawNote = raw.components(separatedBy: "\n\n")
        let notes = try rawNote.map(Note.parse(raw:))
        return Game(notes: notes)
    }
}


@main
struct Day13: Puzzle {
    typealias Input = Game
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension Day13 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 405, fromRaw: raw)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input.notes.map(\.reflectionValue).reduce(0, +)
    }
}

// MARK: - PART 2

extension Day13 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 400, fromRaw: raw)
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        throw ExecutionError.notSolved
    }
}

let raw = """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""
