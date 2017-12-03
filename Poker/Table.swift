//
//  Table.swift
//  Poker
//
//  Created by Jorge Izquierdo on 10/5/15.
//  Copyright © 2015 Jorge Izquierdo. All rights reserved.
//

import Foundation

public struct Table {
    
    public let cards: [Card]
    
    public init(cards: [Card]) {
        self.cards = cards
    }
    
    public func bestHandWithCards(_ cards: [Card]) -> Hand? {
        guard let c = try? combineCards(self.cards + cards) else { return nil }
        
        let orderedHands = c.sorted { bestHand(Hand(cards: $0), Hand(cards: $1)) == Hand(cards: $0) }
        
        guard orderedHands.count > 0 else { return nil }
        return Hand(cards: orderedHands[0])
    }
}

extension Table: CustomStringConvertible {
    public var description: String {
        return self.cards.description
    }
}

func combineCards(_ cards: [Card]) throws -> [[Card]] {
    let combinations = try combine(cards.count, 5)
    return combinations.map { $0.map { cards[$0] } }
}

func combine(_ n: Int, _ k: Int) throws -> [[Int]] {
    
    enum CombineErrors: Error {
        case zeroSets
        case setsBiggerThanMuestra
    }
    
    guard k > 0 else { throw CombineErrors.zeroSets }
    guard n >= k else { throw CombineErrors.setsBiggerThanMuestra }
    
    var retArray = [[Int]]()
    var arr = [Int](repeating: 0, count: k)
    var f: (Int, Int) -> Void = {(_) in}
    f = {
        i, next in
        for j in next..<n {
            arr[i] = j
            if i == k-1 {
                retArray.append(arr)
            } else {
                f(i+1, j+1)
            }
        }
    }
    
    f(0, 0)
    return retArray
}

