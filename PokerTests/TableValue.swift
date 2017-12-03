//
//  Combiantions.swift
//  Poker
//
//  Created by Jorge Izquierdo on 10/19/15.
//  Copyright © 2015 Jorge Izquierdo. All rights reserved.
//

import XCTest
@testable import Poker

class TableValue: XCTestCase {
    
    var table: Table!
    
    override func setUp() {
        table = Table(cards: [.ace |*| .spades, .king |*| .diamonds])
    }
    
    func testPairvsHighcard() {
        
        let hand1 = table.bestHandWithCards([.ace |*| .diamonds, .two |*| .spades, .three |*| .diamonds, .seven |*| .diamonds, .five |*| .hearts])!
        let hand2 = table.bestHandWithCards([.three |*| .spades, .three |*| .clubs, .seven |*| .diamonds, .queen |*| .diamonds, .jack |*| .hearts])!
        
        assertHandValue(bestHand(hand1, hand2).cards, .pair)
    }
    
    func testPokervsStraightFlush() {
        
        let hand1 = table.bestHandWithCards([.ace |*| .diamonds, .ace |*| .hearts, .ace |*| .clubs, .seven |*| .diamonds, .five |*| .hearts])!
        let hand2 = table.bestHandWithCards([.jack |*| .spades, .queen |*| .spades, .seven |*| .diamonds, .king |*| .spades, .ten |*| .spades])!
        
        assertHandValue(bestHand(hand1, hand2).cards, .straightFlush)
    }
}
