//
//  Day12.swift
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



let springParser = Parse(input: Substring.self) {
    OneOf {
        "#".map { SpringState.broken }
        ".".map { SpringState.operational }
        "?".map { SpringState.unknown }
    }
}

let groupParser = Parse(input: Substring.self) {
    Many {
        Int.parser()
    } separator: {
        ","
    }
}

let springGroupParser = Parse(input: Substring.self) {
    Many { springParser }
    " "
    groupParser
}.map(SpringGroup.init)

let parser = Parse(input: Substring.self) {
    Many {
        springGroupParser
    } separator: {
        Whitespace(.vertical)
    } terminator: {
        End()
    }
    .map(Record.init)

}

enum SpringState {
    case unknown
    case operational
    case broken
}

public struct SpringGroup {
    let springs: [SpringState]
    let continuousDamageSize: [Int]
}

struct Record: Parsable {
    let groups: [SpringGroup]
    init(groups: [SpringGroup]) {
        self.groups = groups
    }

    public static func parse(raw: String) throws -> Record {
        try parser.parse(raw[...])
    }
}

@main
struct Day12: Puzzle {
    typealias Input = Record
    typealias OutputPartOne = Never
    typealias OutputPartTwo = Never
}

// MARK: - PART 1

extension Day12 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
//            assert(expectation: 6, fromRaw: basicRaw),
//            assert(expectation: 21, fromRaw: raw)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
//        input.generatedGroups.filter { $0.isValid }.count
        throw ExecutionError.notSolved
    }
}

// MARK: - PART 2

extension Day12 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            // TODO: add expectations for part 2
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        // TODO: Solve part 2 :)
        throw ExecutionError.notSolved
    }
}


let basicRaw = """
#.#.### 1,1,3
.#...#....###. 1,1,3
.#.###.#.###### 1,3,1,6
####.#...#... 4,1,1
#....######..#####. 1,6,5
.###.##....# 3,2,1
"""

let raw = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""


