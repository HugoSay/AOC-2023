//
//  Day10.swift
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


struct Pipe {
    let exit1: Position
    let exit2: Position
}

extension Position {
    var point: CGPoint { CGPoint(x: x, y: y) }
}

//| is a vertical pipe connecting north and south.
//- is a horizontal pipe connecting east and west.
//L is a 90-degree bend connecting north and east.
//J is a 90-degree bend connecting north and west.
//7 is a 90-degree bend connecting south and west.
//F is a 90-degree bend connecting south and east.
//    . is ground; there is no pipe in this tile.
//S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
let pipeType: [Character: Pipe] = [
    "|": Pipe(exit1: Position(x: 0, y: 1), exit2: Position(x: 0, y: -1)),
    "-": Pipe(exit1: Position(x: -1, y: 0), exit2: Position(x: 1, y: 0)),
    "L": Pipe(exit1: Position(x: 0, y: -1), exit2: Position(x: 1, y: 0)),
    "J": Pipe(exit1: Position(x: 0, y: -1), exit2: Position(x: -1, y: 0)),
    "7": Pipe(exit1: Position(x: 0, y: 1), exit2: Position(x: -1, y: 0)),
    "F": Pipe(exit1: Position(x: 0, y: 1), exit2: Position(x: 1, y: 0))
]


final class Game: Parsable {
    let startPosition: Position
    let map: [[Character]]
    var current: Position
    var positions: [Position]
    var previous: Position { positions.last! }

    enum PipeError: Error {
        case nonContinuous
    }

    init(startPosition: Position, map: [[Character]]) {
        self.startPosition = startPosition
        self.map = map
        current = startPosition
        positions = [startPosition, startPosition]

        try? solve()
    }


    func getNextPosition() throws -> Position {
        guard current != startPosition else {
            throw ExecutionError.unsolvable
        }

        let currentPipe = pipe(at: current)
        let nextPosition = if pipeType[currentPipe]!.exit1 &+ current != previous {
            pipeType[currentPipe]!.exit1 &+ current
        } else {
            pipeType[currentPipe]!.exit2 &+ current
        }

        guard isValidNextPosition(nextPosition: nextPosition, current: current) else { throw PipeError.nonContinuous }
        return nextPosition
    }

    func isValidNextPosition(nextPosition: Position, current: Position) -> Bool {
        let nextPipe = pipe(at: nextPosition)
        if nextPipe == "S" { return true }
        guard let nextPipeType = pipeType[nextPipe] else { return false }
        guard nextPosition &+ nextPipeType.exit1 == current || nextPosition &+ nextPipeType.exit2 == current else { return false }
        return true
    }


    func solve() throws {
        let possibleSecongPositions = [
            Position(x: startPosition.x, y: startPosition.y+1),
            Position(x: startPosition.x+1, y: startPosition.y),
            Position(x: startPosition.x-1, y: startPosition.y),
            Position(x: startPosition.x, y: startPosition.y-1)
        ]

        for possibleSecongPosition in possibleSecongPositions {
            guard isValidNextPosition(nextPosition: possibleSecongPosition, current: current) else { continue }
            current = possibleSecongPosition
            while let next = try? getNextPosition() {
                positions.append(current)
                self.current = next
                if next == startPosition {
                    return
                }
            }
        }
        throw ExecutionError.unsolvable
    }

    func part1() -> Int {
        positions.count/2
    }

    func part2() -> Int {
        let path = NSBezierPath()
        path.move(to: startPosition.point)
        positions.map(\.point).forEach { point in
            path.line(to: point)
        }
        path.close()
        let positions = Set(positions)

        var count = 0

        for y in 0 ..< map.count {
            for x in 0 ..< map[0].count { // assume rectangular map
                if !positions.contains(Position(x: x, y: y)) && path.contains(CGPoint(x: x, y: y)) {
                    count += 1
                }
            }
        }
        return count
    }

    func pipe(at position: Position) -> Character {
        map[position.y][position.x]
    }

    public static func parse(raw: String) throws -> Game {
        var startPosition = Position.zero
        let map = raw.components(separatedBy: .newlines)
            .enumerated()
            .map { (y, line) in
                var acc: [Character] = []
                line.enumerated().forEach { x, char in
                    acc.append(char)
                    if char == "S" {
                        startPosition = .init(x: x, y: y)
                    }
                }
                return acc
            }

        return Game(startPosition: startPosition, map: map)
    }


}


@main
struct Day10: Puzzle {
    typealias Input = Game
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}



// MARK: - PART 1

extension Day10 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 4, fromRaw: raw0),
            assert(expectation: 8, fromRaw: raw1)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input.part1()
    }
}

// MARK: - PART 2

import SwiftUI

extension Day10 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 4, fromRaw: part2_1),
            assert(expectation: 8, fromRaw: part2_2),
            assert(expectation: 10, fromRaw: part2_3),
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        input.part2()
    }
}

let raw0 = """
.....
.S-7.
.|.|.
.L-J.
.....
"""

let raw1 = """
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
"""

let part2_1 = """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"""

let part2_2 = """
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
"""

let part2_3 = """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJIF7FJ-
L---JF-JLJIIIIFJLJJ7
|F|F-JF---7IIIL7L|7|
|FFJF7L7F-JF7IIL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""

struct Test: View {
    var body: some View {
        Text("hello")
    }
}

