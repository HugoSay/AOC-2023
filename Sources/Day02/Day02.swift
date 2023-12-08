//
//  Day02.swift
//  AoC-Swift-Template
//  Forked from https://github.com/Dean151/AoC-Swift-Template
//
//  Created by Thomas DURAND.
//  Follow me on Twitter @deanatoire
//  Check my computing blog on https://www.thomasdurand.fr/
//

import Foundation
import Parsing
import CasePaths
import AoC
import Common

enum Cube {
    case r(Int)
    case g(Int)
    case b(Int)
}

struct CubeDraw {
    var r,g,b: Int
}

let cubeParser = Parse(input: Substring.self) {
    OneOf {
        Parse {
            Int.parser()
            " red"
        }
        .map(Cube.r)
        Parse {
            Int.parser()
            " green"
        }
        .map(Cube.g)
        Parse {
            Int.parser()
            " blue"
        }
        .map(Cube.b)
    }
}

let drawParser = Parse(input: Substring.self) {
    Many {
        cubeParser
    } separator: {
        ", "
    }.map { cubes in
        cubes.reduce(into: CubeDraw(r: 0, g: 0, b: 0)) { draw, cube in
            switch cube {
                case .r(let r):
                    draw.r += r
                case .g(let g):
                    draw.g += g
                case .b(let b):
                    draw.b += b
            }
        }
    }
}

//Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
let gameParser = Parse {
    "Game "
    Int.parser()
    ": "
    Many {
        drawParser
    } separator: {
        "; "
    }
}
    .map { Game(id: $0, draws: $1)}

struct Game: Parsable {
    static func parse(raw: String) throws -> Game {
        try gameParser.parse(raw[...])
    }
    
    let id: Int
    let draws: [CubeDraw]
    let startingState: CubeDraw = .init(r: 12, g: 13, b: 14)

    var isPossible: Bool {
        draws.allSatisfy { cubeDraw in
            cubeDraw.r <= startingState.r
            && cubeDraw.g <= startingState.g
            && cubeDraw.b <= startingState.b
        }
    }

    var debug: String {
        draws.map { draw in
            "r:\(draw.r), g:\(draw.g), b:\(draw.b)"
        }.joined(separator: "; ")
    }
    var idIfPossible: Int? {
        isPossible ? id : nil
    }

    var power: Int {
        var minR = 0
        var minG = 0
        var minB = 0

        draws.forEach { draw in
            minR = max(draw.r, minR)
            minG = max(draw.g, minG)
            minB = max(draw.b, minB)
        }
        return minR * minG * minB
    }
}

@main
struct Day02: Puzzle {
    typealias Input = [Game]
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension Day02 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            // TODO: add expectations for part 1
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input.compactMap(\.idIfPossible).reduce(0, +)
    }
}

// MARK: - PART 2

extension Day02 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 2286, fromRaw: "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green\nGame 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue\nGame 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red\nGame 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red\nGame 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green")
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        input.map(\.power).reduce(0, +)
    }
}


struct feat2 {
    func test() {
        // just creating the interface for now
    }
}
