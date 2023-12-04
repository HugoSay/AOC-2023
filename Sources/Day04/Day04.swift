//
//  Day04.swift
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



struct Card {
    let id: Int
    let numbers: Set<Int>
    let winning: Set<Int>

    var points: Int {
        let winningNumbers = numbers.intersection(winning)

        return Int(pow(2.0, Double(winningNumbers.count - 1)))
    }

    var numberOfCopies: Int { numbers.intersection(winning).count }
}


let cardParser = Parse(input: Substring.self) {
    "Card"; Whitespace(.horizontal)
    Int.parser()
    ":"; Whitespace(.horizontal)
    Many {
        Int.parser()
    } separator: {
        Whitespace(.horizontal)
    }
    Whitespace(.horizontal); "|"; Whitespace(.horizontal)
    Many {
        Int.parser()
    } separator: {
        Whitespace(.horizontal)
    }
}.map { Card(id: $0, numbers: Set($1), winning: Set($2)) }

let drawParser = Parse(input: Substring.self) {
    Many {
        cardParser
    } separator: {
        Whitespace(.vertical)
    }
}

@main
struct Day04: Puzzle {
    typealias Input = String
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension Day04 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 13, fromRaw: raw)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        let draw = try drawParser.parse(input[...])

        return draw.map(\.points).reduce(0, +)
    }
}

// MARK: - PART 2

extension Day04 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 30, fromRaw: raw)
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        var draw = try drawParser.parse(input[...])
        var cardsByID = Dictionary(grouping: draw, by: \.id)


        for key in draw.map(\.id) {
            cardsByID[key]?.forEach{ card in
                let numberOfCopies = card.numberOfCopies
                if numberOfCopies > 0 {
                    for i in 1 ... numberOfCopies {
                        guard let copiedCard = cardsByID[key + i]?.first else { break }
                        cardsByID[key + i]?.append(copiedCard)
                    }
                }
            }
        }

        return cardsByID.reduce(0) { partialResult, keyValue in
            partialResult + keyValue.1.count
        }
    }
}


let raw = """
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""
