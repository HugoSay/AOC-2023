//
//  Day07.swift
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

let cardRankMap: [Character: Int] = [
    "2": 2, "3": 3, "4": 4, "5": 5, "6": 6,
    "7": 7, "8": 8, "9": 9, "T": 10,
    "J": 11, "Q": 12, "K": 13, "A": 14
]

let cardRankMap2: [Character: Int] = [
    "2": 2, "3": 3, "4": 4, "5": 5, "6": 6,
    "7": 7, "8": 8, "9": 9, "T": 10,
    "J": -1, "Q": 12, "K": 13, "A": 14
]

struct PokerHand: Comparable {
    enum Kind: String {
        case fiveOfAKind
        case fourOfAKind
        case fullHouse
        case threeOfAKind
        case twoPair
        case onePair
        case highCard
       
        var rank: Int {
            switch self {
                case .fiveOfAKind: return 7
                case .fourOfAKind: return 6
                case .fullHouse: return 5
                case .threeOfAKind: return 4
                case .twoPair: return 3
                case .onePair: return 2
                case .highCard: return 1
            }
        }
    }
    let kind: Kind
    let cardValues: [Int]


    static func < (lhs: PokerHand, rhs: PokerHand) -> Bool {

        if lhs.kind.rank != rhs.kind.rank {
            return lhs.kind.rank < rhs.kind.rank
        } else {
            for i in 0..<lhs.cardValues.count {
                if lhs.cardValues[i] != rhs.cardValues[i] {
                   return lhs.cardValues[i] < rhs.cardValues[i]
                }
            }
            return false
        }

    }
}

func parsePokerHand(from handString: String) -> PokerHand? {
    guard handString.count == 5 else { return nil }

    // Count the frequency of each character
    let frequencies = Dictionary(handString.map { ($0, 1) }, uniquingKeysWith: +)
    let handRanks = handString.map {cardRankMap[$0]!}

    switch frequencies.values.sorted(by: >) {
        case [5]:
            // Five of a kind
            return .init(kind: .fiveOfAKind, cardValues: handRanks)

        case [4, 1]:
            // Four of a kind
            return .init(kind: .fourOfAKind, cardValues: handRanks)

        case [3, 2]:
            // Full house
            return .init(kind: .fullHouse, cardValues: handRanks)

        case [3, 1, 1]:
            // Three of a kind
            return .init(kind: .threeOfAKind, cardValues: handRanks)

        case [2, 2, 1]:
            // Two pair
            return .init(kind: .twoPair, cardValues: handRanks)

        case [2, 1, 1, 1]:
            // One pair
            return .init(kind: .onePair, cardValues: handRanks)

        case [1, 1, 1, 1, 1]:
            // High card
            return .init(kind: .highCard, cardValues: handRanks)

        default:
            // Invalid hand
            return nil
    }
}

func parsePokerHand2(from handString: String) throws -> PokerHand {
    // Count the frequency of each character
    var frequencies = Dictionary(handString.map { ($0, 1) }, uniquingKeysWith: +)

    let numberOfJacks = frequencies["J", default: 0]
    let maxFrequency = frequencies.max { $0.value <  $1.value }!
    if maxFrequency.key != "J" {
        frequencies[maxFrequency.key]! += numberOfJacks
        frequencies["J"] = nil
    } else if frequencies.count != 1 { //case where there are only jacks
        frequencies.removeValue(forKey: "J")
        let maxFrequency = frequencies.max { $0.value <  $1.value }!
        frequencies[maxFrequency.key]! += numberOfJacks
    }
    let handRanks = handString.map {cardRankMap2[$0]!}

    switch frequencies.values.sorted(by: >) {
        case [5]:
            // Five of a kind
            return .init(kind: .fiveOfAKind, cardValues: handRanks)

        case [4, 1]:
            // Four of a kind
            return .init(kind: .fourOfAKind, cardValues: handRanks)

        case [3, 2]:
            // Full house
            return .init(kind: .fullHouse, cardValues: handRanks)

        case [3, 1, 1]:
            // Three of a kind
            return .init(kind: .threeOfAKind, cardValues: handRanks)

        case [2, 2, 1]:
            // Two pair
            return .init(kind: .twoPair, cardValues: handRanks)

        case [2, 1, 1, 1]:
            // One pair
            return .init(kind: .onePair, cardValues: handRanks)

        case [1, 1, 1, 1, 1]:
            // High card
            return .init(kind: .highCard, cardValues: handRanks)

        default:
            print("WTF TWF TWF")
            throw "wtf, \(handString), \(frequencies)"

    }
}

class Hand {
    let cards: String
    let bid: Int

    let handValue: PokerHand

    init(cards: String, bid: Int) {
        self.cards = cards
        self.bid = bid
        self.handValue = parsePokerHand(from: cards)!
    }

    static let parser: AnyParser<Substring, Hand> = Parse(input: Substring.self) {
        PrefixUpTo(" ")
        Whitespace(.horizontal)
        Int.parser()
    }.map { cards, bid in
        Hand(cards: String(cards), bid: bid)
    }.eraseToAnyParser()
}

struct Game: Parsable {
    let hands: [Hand]

    static let gameParser = Parse(input: Substring.self) {
        Many { Hand.parser } separator: {
            Whitespace(.vertical)
        }
        .map(Game.init(hands:))
    }

    static func parse(raw: String) throws -> Game {
        try gameParser.parse(raw[...])
    }
}

@main
struct Day07: Puzzle {
    typealias Input = Game
    typealias OutputPartOne = Int
    typealias OutputPartTwo = Int
}

// MARK: - PART 1

extension Day07 {
    static var partOneExpectations: [any Expectation<Input, OutputPartOne>] {
        [
            assert(expectation: 6440, fromRaw: raw)
        ]
    }

    static func solvePartOne(_ input: Input) async throws -> OutputPartOne {
        input.hands.sorted(by: { $0.handValue < $1.handValue })
            .enumerated()
            .map { ($0+1) * $1.bid }
            .reduce(0, +)
    }
}

// MARK: - PART 2

extension Day07 {
    static var partTwoExpectations: [any Expectation<Input, OutputPartTwo>] {
        [
            assert(expectation: 5905, fromRaw: raw),
//            JKKK2 is weaker than QQQQ2 because J is weaker than Q.
            assert(expectation: 2, from: .init(hands: [Hand.init(cards: "JKKK2", bid: 0), .init(cards: "QQQQ2", bid: 1)]))
        ]
    }

    static func solvePartTwo(_ input: Input) async throws -> OutputPartTwo {
        return try input.hands.sorted(by: { try parsePokerHand2(from: $0.cards) < parsePokerHand2(from: $1.cards) })
            .enumerated()
            .map { ($0+1) * $1.bid }
            .reduce(0, +)
    }
}

let raw = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""
