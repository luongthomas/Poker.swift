//
//  Hand.swift
//  Poker
//
//  Created by Jorge Izquierdo on 9/22/15.
//  Copyright © 2015 Jorge Izquierdo. All rights reserved.
//

public struct Hand {
    
    public let cards: [Card]
    
    public init(cards: [Card]) {
        self.cards = cards
    }
    
    public enum Value: Int {

        case highCard = 0
        case pair
        case doublePair
        case threeOfAKind
        case straight
        case flush
        case fullHouse
        case fourOfAKind
        case straightFlush
    }
    
    public struct RealValue: CustomStringConvertible {
        let value: Value
        let order: [Number]
        public var description: String {
            return String(describing: value) + self.order.reduce(" ") { $0 + $1.emojiValue }
        }
    }
    
    public func valueHand() -> RealValue {
        let numbers = self.cards.map { $0.number }
        
        // Shared detections
        let (isFlush, flushNumbers) = detectFlush(self.cards)
        let (isStraight, straightNumbers) = detectStraight(numbers)
        let (isPair, pairNumbers) = detectGroup(numbers, count: 2) // Detect first pair
        let (isTrio, trioNs) = detectGroup(numbers, count: 3)
        
        // Check for Straight Flush
        guard !isFlush || !isStraight else { return RealValue(value: .straightFlush, order: straightNumbers)}
        
        // Check for Four of a Kind
        let (isFour, fourNs) = detectGroup(numbers, count: 4)
        guard !isFour else { return RealValue(value: .fourOfAKind, order: fourNs) }
        
        // Check for full
        let (isFullPair, fullNumbers) = detectGroup(trioNs, count: 2)
        guard !isPair || !isFullPair else {
            
            let firsts = [trioNs[0], fullNumbers[0]]
            let merged = firsts + fullNumbers.filter { !firsts.contains($0) }
            
            return RealValue(value: .fullHouse, order: merged)
        }
        
        // Check for Flush
        guard !isFlush else { return RealValue(value: .flush, order: flushNumbers)}
        
        // Check for Straight
        guard !isStraight else { return RealValue(value: .straight, order: straightNumbers)}
        
        // Check for Three of a Kind
        guard !isTrio else { return RealValue(value: .threeOfAKind, order: trioNs) }
        
        // Check for Double Pair
        let (p2, n2) = detectGroup(pairNumbers, count: 2)
        guard !isPair || !p2 else {
            
            let firsts = [max(pairNumbers[0], n2[0]), min(pairNumbers[0], n2[0])] // First in the array are the paired numbers ordered
            let merged = firsts + n2.filter { !firsts.contains($0) } // And then all the order numbers
            return RealValue(value: .doublePair, order: merged)
        }
        
        // Check for Pair
        guard !isPair else { return RealValue(value: .pair, order: pairNumbers) }
        
        // Last option is just high card
        return RealValue(value: .highCard, order: numbers.sorted { $0.rawValue > $1.rawValue })
    }

}

public func bestHand(_ hand1: Hand, _ hand2: Hand) -> Hand {
    
    let v1 = hand1.valueHand()
    let v2 = hand2.valueHand()
    
    // Direct value
    if v1.value.rawValue > v2.value.rawValue { return hand1 }
    if v2.value.rawValue > v1.value.rawValue { return hand2 }
    
    // Compare numbers
    
    // We assume the same amount of numbers, since the value is the same, numbers should be the same
    for (one, two) in zip(v1.order, v2.order) {
        if one > two { return hand1 }
        if two > one { return hand2 }
    }
    
    // If we come to the end and it hasn't returned, it means there is a tie. So we can return whatever hand
    return hand1
}

extension Hand: CustomStringConvertible {
    public var description: String {
        return self.cards.reduce("Hand: ") { $0 + $1.description + " " }
    }
}

extension Hand: Equatable {
}

public func ==(lhs: Hand, rhs: Hand) -> Bool {
    let c1 = lhs.cards
    let c2 = rhs.cards
    
    guard c1.count == c2.count else { return false }
    for i in 0..<c1.count {
        if c1[i] != c2[i] { return false }
    }
    
    return true
}

// This function is a bit dirty, it could use some refactor
func detectStraight(_ numbers: [Number]) -> (Bool, [Number]){
    
    // Beware of the ace. It can be used in A2345 and 10JQKA
    let sortedNumbers = numbers.flatMap { $0.straightValues }.sorted()
    
    // Add one error allowed to account for if
    // Ace is at the beginning of sortedNumbers AND end of sortedNumbers (0 and 13 respectively)
    
    var allowedErrors = sortedNumbers.count - numbers.count + 1
    
    guard sortedNumbers.count <= numbers.count + 1 else { return (false, [])}
    
    var previousCardValue = sortedNumbers[0]
    var currentHighestRunningStraightValue = sortedNumbers[0]
    
    let allowedDifferenceBetweenTwoCards = 1
    
    // Fixed test by iterating only to the count - 1th element
    for i in 1..<sortedNumbers.count - 1 {
        let currentCardValue = sortedNumbers[i]
        
        if currentCardValue - previousCardValue != allowedDifferenceBetweenTwoCards {
            // There is a gap of 2(+) between the card values
            allowedErrors -= 1
            if allowedErrors <= 0 {
                return (false, [])
            }
        } else {
            currentHighestRunningStraightValue = currentCardValue
        }
        previousCardValue = sortedNumbers[i]
    }
    
    return (true, [Number(rawValue: currentHighestRunningStraightValue)!])
}

func detectFlush(_ cards: [Card]) -> (Bool, [Number]) {
    
    let firstCard = cards[0]
    let sameSuit = cards.filter { $0.suit == firstCard.suit }
    
    guard sameSuit.count == cards.count else { return (false, []) }
    
    let orderedNumbers = cards.map { $0.number }.sorted { $0.rawValue > $1.rawValue }
    
    return (true, orderedNumbers)
}

func detectGroup(_ numbers: [Number], count: Int) -> (Bool, [Number]) {
    
    let frecuencies = numberFrecuencies(numbers)
    let paired = frecuencies.filter {
        _, v in
        v == count
        }.map {
            k,_ in
            k
    }
    
    guard paired.count > 0 else { return (false, []) }
    let pair = paired[0]
    let notPaired = numbers.map { $0.rawValue }.filter { $0 != pair }.sorted { $0 > $1 }
    let remaining = ([pair] + notPaired).map { Number(rawValue: $0)! }
    return (true, remaining)
}

func numberFrecuencies(_ numbers: [Number]) -> [Int:Int] {
    return numbers.map { $0.rawValue }.reduce([Int:Int]()) {
        a, e in
        var newa = a
        newa[e] = (a[e] ?? 0) + 1
        return newa
    }
}

