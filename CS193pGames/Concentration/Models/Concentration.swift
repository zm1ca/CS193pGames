//
//  Concentration.swift
//  Concentration
//
//  Created by Źmicier Fiedčanka on 4.12.20.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [ConcentrationCard]()
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    private(set) var score = 0
    private var cardsWhichUserHaseAlreadySeen = [ConcentrationCard]()
    private var latestPickTime: Date?
    private var scoreMultiplier: Int {
        let pickTime = -latestPickTime!.timeIntervalSinceNow
        switch pickTime {
        case 0..<0.25:  return 5
        case 0.25..<1:  return 3
        case 1..<5:     return 1
        default:        return 0
        }
    }
    
    var gameIsOver: Bool { cards.filter({$0.isMatched == false}).isEmpty }

    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(numberOfPairsOfCards: \(numberOfPairsOfCards): you must have at least one pair of cards ")
        for _ in 0..<numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        
        cards.shuffle()
    }
    
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): chosen index not in cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched      = true
                    score += 2 * scoreMultiplier
                } else {
                    checkIfUserSeenCard(cards[index])
                    checkIfUserSeenCard(cards[matchIndex])
                }
                
                cards[index].isFaceUp = true
            } else {
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                 latestPickTime = Date()
            }
        }
    }
    
    
    mutating  private func checkIfUserSeenCard(_ card: ConcentrationCard) {
        if cardsWhichUserHaseAlreadySeen.contains(where: { $0 == card}) {
            score -= 3
        } else {
            cardsWhichUserHaseAlreadySeen.append(card)
        }
    }
}


extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
