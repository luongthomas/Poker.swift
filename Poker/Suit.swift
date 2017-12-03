//
//  Suit.swift
//  Poker
//
//  Created by Jorge Izquierdo on 9/22/15.
//  Copyright © 2015 Jorge Izquierdo. All rights reserved.
//

public enum Suit: Int {
    case clubs = 0
    case hearts
    case diamonds
    case spades
    
    static func allSuits() -> [Suit] {
        return [.clubs, .hearts, .diamonds, .spades]
    }
}

extension Suit: Emojiable {
    var emojiValue: String {
        switch self {
        case .clubs: return "♣️"
        case .hearts: return "♥️"
        case .diamonds: return "♦️"
        case .spades: return "♠️"
        }
    }
}
