//
//  Day05.swift
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
struct Day05: Puzzle {
    typealias Input = Game
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension Game: Parsable {
    static func parse(raw: String) throws -> Game {
        return try gameParser.parse(raw[...])
    }
}

extension Day05 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 35, fromRaw: raw)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input.solve(for: input.seeds)
    }
}

// MARK: - PART 2

extension Day05 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 46, fromRaw: raw)
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        input.solve(for: input.seeds2)
    }
}

func apply(_ map: Map, to val: Int) -> Int {
    guard map.sourceRange.contains(val) else {
        return val
    }
    return map.destinationRange.lowerBound + val - map.sourceRange.lowerBound
}

struct Map {
    let sourceRange: Range<Int>
    let destinationRange: Range<Int>

    init(destination: Int, source: Int, length: Int) {
        sourceRange = source..<source+length
        destinationRange = destination..<destination+length
    }
}

struct Step {
    let name: String
    let maps: [Map]
}

struct Game {
    let seeds: [Int]
    let steps: [Step]
    let seeds2: [Int]
    init(seeds: [Int], steps: [Step]) {
        self.seeds = seeds
        self.steps = steps
        seeds2 = (seeds[0]..<seeds[0] + seeds[1]).map { $0 } + (seeds[2]..<seeds[2] + seeds[3]).map { $0 }
    }

    func solve(for seeds: [Int]) -> Int {
        let seeds = seeds.map { inputSeed in
            var seed = inputSeed
            steps.forEach { step in
                for map in step.maps {
                    let old = seed
                    let new = apply(map, to: seed)
                    seed = new
                    if new != old { break }
                }
            }
            return seed
        }
        return seeds.min()!
    }
}

let rangeParser = Parse(input: Substring.self) {
    Int.parser()
    Whitespace(.horizontal)
    Int.parser()
    Whitespace(.horizontal)
    Int.parser()
}.map { Map(destination: $0, source: $1, length: $2) }

let stepParser = Parse(input: Substring.self) {
    PrefixThrough("map:"[...])
    Whitespace(.vertical)

    Many {
        rangeParser
    }
separator: {
    Whitespace(.vertical)
}
    Whitespace(.vertical)
}.map { Step(name: String($0), maps: $1) }

let gameParser = Parse(input: Substring.self) {
    "seeds: "; Many { Int.parser() } separator: { Whitespace(.horizontal) }
    Whitespace(.vertical)
    Many {
        stepParser
    }
}.map { seeds, maps in
    Game(seeds: seeds, steps: maps)
}


let raw = """
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"""
