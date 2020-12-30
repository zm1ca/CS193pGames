//
//  Set.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 5.12.20.
//

import Foundation

class GameOfSet {
    
    var score = 0
    private(set) var latestActionTime = Date()
    
    enum ActionResult {
        case match
        case deselect
        case excessiveDraw
        case mismatch
        case hintUsed
    }
    
    private(set) var deck           = [Card]()
    private(set) var cardsOnTable   = [Card]()
    
    var selectedCardsIndices = [Int]()
    var selectedCardsAreSet: Bool {
        thereIsSet(at: selectedCardsIndices)
    }
    
    private var hintUsed = false
    
    var hintSetIndices: [Int]? {
        guard cardsOnTable.count > 2 else { return nil }
        
        for i in 0..<cardsOnTable.count - 2 {
            for j in (i + 1)..<cardsOnTable.count - 1 {
                for k in (j + 1)..<cardsOnTable.count {
                    if thereIsSet(at: [i, j, k]) {
                        return [i, j, k]
                    }
                }
            }
        }
        return nil
    }
    
    
    init() {
        for numberOfShapes in 0..<3 {
            for shape in 0..<3 {
                for shading in 0..<3 {
                    for color in 0..<3 {
                        deck.append(Card(numberOfShapes: numberOfShapes,
                                         shape: shape,
                                         shading: shading,
                                         color: color)
                        )
                    }
                }
            }
        }
        deck.shuffle()
        for _ in 0..<12 { cardsOnTable.append(deck.removeLast()) }
    }
    
    
    //MARK: Public API
    
    func shuffleCardsOnTable() {
        updateScoreIfMatchOrMismatch()
        selectedCardsIndices = []
        cardsOnTable.shuffle()
    }
    
    
    func drawThreeMoreCards() {
        if selectedCardsAreSet {
            if !hintUsed { updateScore(for: .match) }
            cardsOnTable.remove(at: selectedCardsIndices)
        } else {
            if !cardsOnTable.isEmpty, hintSetIndices != nil {
                updateScore(for: .excessiveDraw)
            }
        }
        selectedCardsIndices = []
        
        
        guard deck.count >= 3 else { return }
        
        for _ in 0..<3 {
            cardsOnTable.append(deck.removeLast())
        }
        
        hintUsed = false
    }
    
    
    func getHint() {
        guard let hintSetIndices = hintSetIndices else {
            print("[Excessive call]: Hint asked but there's nothing to show")
            return
        }
        
        hintUsed = true
        selectedCardsIndices = hintSetIndices
        updateScore(for: .hintUsed)
    }
    
    
    func selectCard(at index: Int) {
        if selectedCardsIndices.contains(index)  {
            selectedCardsIndices.remove(at: selectedCardsIndices.firstIndex(of: index)!)
            updateScore(for: .deselect)
        } else {
            if selectedCardsIndices.count < 3 {
                selectedCardsIndices.append(index)
            } else {
                let indComp = indexCompensation(for: index)
                updateScoreIfMatchOrMismatch()
                selectedCardsIndices = [index - indComp]
            }
        }
        
        hintUsed = false
    }
    
    
    //MARK: Private functions
    
    private func indexCompensation(for index: Int) -> Int {
        if selectedCardsAreSet {
            var ext = selectedCardsIndices
            ext.append(index)
            return ext.sorted(by: <).firstIndex(of: index)!
        }
        return 0
    }
    
    
    private func thereIsSet(at indices: [Int]) -> Bool {
        guard indices.count == 3 else { return false }
        
        let cards = [cardsOnTable[indices[0]],
                     cardsOnTable[indices[1]],
                     cardsOnTable[indices[2]]]

        var shapes          = Set<Int>()
        var numbersOfShapes = Set<Int>()
        var shadings        = Set<Int>()
        var colors          = Set<Int>()
        
        for card in cards {
            shapes.insert(card.shape)
            numbersOfShapes.insert(card.numberOfShapes)
            shadings.insert(card.shading)
            colors.insert(card.color)
        }
        
        if (shapes.count == 2) || (numbersOfShapes.count == 2) || (shadings.count == 2) || (colors.count == 2) {
            return false
        }
        
        return true
    }
    
    
    func score(for actionResult: ActionResult) -> Int {
        let timeToPerformAction = -latestActionTime.timeIntervalSinceNow
        latestActionTime = Date()
        
        var scoreBase: Int
        switch actionResult {
        case .match:         scoreBase = 3
        case .deselect:      scoreBase = -1
        case .excessiveDraw: scoreBase = -2
        case .mismatch:      scoreBase = -3
        case .hintUsed:      scoreBase = -4
        }
        
        var scoreMultiplier: Int
        switch timeToPerformAction {
        case 0..<10:    scoreMultiplier = 4
        case 10..<30:   scoreMultiplier = 3
        case 30..<120:  scoreMultiplier = 2
        default:        scoreMultiplier = 1
        }
        
        return scoreBase * scoreMultiplier
    }
    
    
    func updateScore(for actionResult: ActionResult) {
        score += score(for: actionResult)
    }
    
    
    //TODO: That api feels to be poor (both implementation and usage)
    func updateScoreIfMatchOrMismatch() {
        guard selectedCardsIndices.count == 3 else { return }
        
        if selectedCardsAreSet {
            if !hintUsed { updateScore(for: .match) }
            cardsOnTable.remove(at: selectedCardsIndices)
        } else {
            updateScore(for: .mismatch)
        }
    }
}
