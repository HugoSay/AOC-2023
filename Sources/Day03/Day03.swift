//
//  Day03.swift
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

typealias Position = SIMD2<Int>

struct Game {
    var parts: [Part]
    var symbols: [Symbol]
}

struct Symbol {
    let char: Character
    let position: Position
    
    var isGear: Bool { char == "*" }
}

struct Part: Hashable {
    var raw: [Character]
    var val: Int { Int(String(raw))! }
    let basePosition: Position

    var adjacent: Set<Position> {
        var set = Set([basePosition])
        for i in 0..<raw.count {
            for dx in -1...1 {
                for dy in -1...1 {
                    if dx != 0 || dy != 0 { // Exclude the position of the digit itself
                        let adjPos = basePosition &+ Position(x: i, y: 0) &+ Position(x: dx, y: dy)
                        set.insert(adjPos)
                    }
                }
            }
        }
        return set
    }


    func isAPart(symbols: Set<Position>) -> Bool {
        return !symbols.intersection(self.adjacent).isEmpty
    }
}

extension Game: Parsable {
    static func parse(raw: String) throws -> Game {
        var currentPart: Part?
        var game = Game(parts: [], symbols: [])

        func appendCurrentPartIfNeeded() {
            if let part = currentPart {
                game.parts.append(part)
                currentPart = nil
            }
        }

        for (lineNumber, line) in raw.components(separatedBy: .newlines).enumerated() {
            for (index, char) in line.enumerated() {
                if char.isWholeNumber {
                    if currentPart != nil {
                        currentPart!.raw.append(char)
                    } else {
                        currentPart = Part(raw: [char], basePosition: .init(x: index, y: lineNumber))
                    }
                } else {
                    appendCurrentPartIfNeeded()
                    if char != "." {
                        game.symbols.append(Symbol(char: char, position: Position(x: index, y: lineNumber)))
                    }
                }
            }
            appendCurrentPartIfNeeded()
        }
        
        appendCurrentPartIfNeeded()
        return game
    }
}

@main
struct Day03: Puzzle {
    typealias Input = Game
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

let rawExemple = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

extension Day03 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 4361, fromRaw: rawExemple)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        let symbols = Set(input.symbols.map(\.position))
        return input.parts.map { part in
            part.isAPart(symbols: symbols) ? part.val : 0
        }
        .reduce(0, +)
    }
}

// MARK: - PART 2

extension Day03 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            // TODO: add expectations for part 2
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        let gears = input.symbols.filter(\.isGear)
        let parts = input.parts.filter { $0.isAPart(symbols: Set(gears.map(\.position)))}

        return gears.reduce(0) { partialResult, gear in
            let adjacents = parts.filter { $0.isAPart(symbols: [gear.position] )}
            if adjacents.count == 2 {
                return partialResult + adjacents.map(\.val).reduce(1, *)
            } else {
                return partialResult
            }
        }
    }
}
