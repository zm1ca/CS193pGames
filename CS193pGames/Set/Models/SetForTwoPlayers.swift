//
//  SetForTwoPlayers.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 8.12.20.
//

import Foundation

class SetForTwoPlayers: GameOfSet {
    
    var secondPlayersScore  = 0
    var secondPlayersTurn   = false {
        willSet {
            updateScoreIfMatchOrMismatch()
            selectedCardsIndices = []
        }
    }
    
    override func updateScore(for actionResult: GameOfSet.ActionResult) {
        let scoreIncrement = score(for: actionResult)
        
        if secondPlayersTurn {
            secondPlayersScore += scoreIncrement
        } else {
            score += scoreIncrement
        }
    }
}
