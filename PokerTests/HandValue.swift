//
//  HandValue.swift
//  Poker
//
//  Created by Jorge Izquierdo on 9/23/15.
//  Copyright © 2015 Jorge Izquierdo. All rights reserved.
//

import XCTest
@testable import Poker

class HandValue: XCTestCase {
    
    func testHighcard() {
        let cards = [.ace |*| .spades, .three |*| .clubs, .seven |*| .diamonds, .king |*| .diamonds, .jack |*| .hearts]
        assertHandValue(cards, .highCard)
    }
    
    func testPair() {
        let cards = [.ace |*| .spades, .ace |*| .clubs, .seven |*| .diamonds, .king |*| .diamonds, .jack |*| .hearts]
        assertHandValue(cards, .pair)
    }
    
    func testDoublePair() {
        let cards = [.ace |*| .spades, .ace |*| .clubs, .seven |*| .diamonds, .jack |*| .diamonds, .jack |*| .hearts]
        print(Hand(cards: cards).valueHand())
        assertHandValue(cards, .doublePair)
    }
    
    func testThreeOfAKind() {
        let cards = [.ace |*| .spades, .ace |*| .clubs, .ace |*| .diamonds, .king |*| .diamonds, .jack |*| .hearts]
        print(Hand(cards: cards).valueHand())
        assertHandValue(cards, .threeOfAKind)
    }
    
    func testFullHouse() {
        let cards = [.ace |*| .spades, .ace |*| .clubs, .king |*| .diamonds, .king |*| .diamonds, .king |*| .hearts]
        print(Hand(cards: cards).valueHand())
        assertHandValue(cards, .fullHouse)
    }
    
    func testFlush() {
        let cards = [.ace |*| .spades, .ace |*| .spades, .seven |*| .spades, .king |*| .spades, .jack |*| .spades]
        print(Hand(cards: cards).valueHand())
        assertHandValue(cards, .flush)
    }
    
    func testStraight() {
        let cards = [.ace |*| .spades, .two |*| .clubs, .three |*| .diamonds, .four |*| .diamonds, .five |*| .hearts]
        print(Hand(cards: cards).valueHand())
        assertHandValue(cards, .straight)
    }
    
    func testFourOfAKind() {
        let cards = [.ace |*| .spades, .two |*| .clubs, .ace |*| .diamonds, .ace |*| .diamonds, .ace |*| .hearts]
        print(Hand(cards: cards).valueHand())
        assertHandValue(cards, .fourOfAKind)
    }
    
    func testStraightFlush() {
        let cards = [.ace |*| .spades, .two |*| .spades , .three |*| .spades, .four |*| .spades, .five |*| .spades]
        print(Hand(cards: cards).valueHand())
        assertHandValue(cards, .straightFlush)
    }
    
    func testAceHighFlush() {
        let cards = [.jack |*| .spades, .queen |*| .spades, .ace |*| .spades, .king |*| .spades, .ten |*| .spades]
        print(Hand(cards: cards).valueHand())
        assertHandValue(cards, .straightFlush)
    }
    
}

func assertHandValue(_ cards: [Card], _ value: Hand.Value) {
    
     XCTAssertEqual(Hand(cards: cards).valueHand().value, value)
}
