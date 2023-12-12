//
//  Day11.swift
//  AoC-Swift-Template
//  Forked from https://github.com/Dean151/AoC-Swift-Template
//
//  Created by Thomas DURAND.
//  Follow me on Twitter @deanatoire
//  Check my computing blog on https://www.thomasdurand.fr/
//

import Foundation
import Algorithms
import AoC
import Common

final class Universe: Parsable {
    let galaxies: [Position]
    let maxX, maxY: Int

    init(galaxies: [Position], maxX: Int, maxY: Int) {
        self.galaxies = galaxies
        self.maxX = maxX
        self.maxY = maxY
    }

    public static func parse(raw: String) throws -> Universe {
        var galaxies: [Position] = []
        var maxX: Int = 0
        var maxY: Int = 0
        raw.components(separatedBy: .newlines)
            .enumerated()
            .forEach { (y, line) in
                line.enumerated().forEach { x, char in
                    if char == "#" {
                        galaxies.append(.init(x: x, y: y))
                        maxX = x
                        maxY = y
                    }
                }
            }

        return Universe(galaxies: galaxies, maxX: maxX, maxY: maxY)
    }

    func solve(expansion: Int) -> Int {
        var galaxies = galaxies
        let x = galaxies.map(\.x)
        let y = galaxies.map(\.y)
        let colToAdd = (0..<maxX).filter { col in
            !x.contains(col)
        }

        let linesToAdd = (0..<maxY).filter { line in
            !y.contains(line)
        }

        colToAdd.reversed().forEach { col in
            galaxies = galaxies.map({ $0.x <= col ? $0 : $0 &+ Position(x: expansion, y: 0) })
        }

        linesToAdd.reversed().forEach { line in
            galaxies = galaxies.map({ $0.y <= line ? $0 : $0 &+ Position(x: 0, y: expansion) })
        }

        return galaxies.enumerated().reduce(into: 0) { partialResult, position in
            for i in position.offset..<galaxies.count {
//                print(position.offset, i, position.element.description, galaxies[i].description, position.element.distance(to: galaxies[i]))
                partialResult += position.element.distance(to: galaxies[i])
            }
        }
    }
}


extension Position {
    func distance(to other: Position) -> Int {
        abs(other.x - x) + abs(other.y - y)
    }
}

@main
struct Day11: Puzzle {
    typealias Input = Universe
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension Day11 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 374, fromRaw: raw)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input.solve(expansion: 1)
    }
}

// MARK: - PART 2

extension Day11 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        input.solve(expansion: 1_000_000 - 1)
    }
}


let raw = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"""
