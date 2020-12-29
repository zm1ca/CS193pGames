//
//  ViewController.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 5.12.20.
//

import UIKit

class GameOfSetVC: UIViewController {
    
    var game = SetForTwoPlayers()
    
    @IBOutlet weak var infoStackView:           UIStackView!
    @IBOutlet weak var hintButton:              UIButton!
    @IBOutlet weak var resetButton:             UIButton!
    @IBOutlet weak var barHintButton:           UIButton!
    @IBOutlet weak var barResetButton:          UIButton!
    
    @IBOutlet var swipeDownGestureRecognizer:    UISwipeGestureRecognizer!
    @IBOutlet weak var firstPlayerScoreLabel:    UILabel!
    @IBOutlet weak var secondPlayersScoreLabel:  UILabel!
    @IBOutlet weak var deckButton:               UIButton!
    @IBOutlet weak var cardsGridView:            CardsGridView!
    
    var glowTypeForSelectedCards: GlowType {
        if game.selectedCardsIndices.count < 3 {
            return .selected
        } else {
            return game.selectedCardsAreSet ? .matched : .mismatched
        }
    }

    
    //MARK:- IBActions
    @IBAction func switchPlayerTapGestureRecognised(_ sender: Any) {
        game.secondPlayersTurn.toggle()
        updateViewFromModel()
    }

    
    @IBAction func hintButtonTapped(_ sender: Any) {
        game.getHint()
        updateViewFromModel()
    }
    

    @IBAction func drawThreeMoreCards(_ sender: Any) {
        game.drawThreeMoreCards()
        updateViewFromModel()
    }
    
    
    @IBAction func newGameButtonTapped(_ sender: Any) {
        cardsGridView.presentedCardViews = []
        cardsGridView.removeAllSubviews()
        game = SetForTwoPlayers()
        updateViewFromModel()
    }
    
    
    @IBAction func rotationGestureDetected(_ sender: UIGestureRecognizer) {
        //prevent firing off that action too fast with timer
        game.shuffleCardsOnTable()
        updateViewFromModel()
    }
    
    
    //MARK:- Configuring UI
    override func viewDidLoad() {
        super.viewDidLoad()
        cardsGridView.delegate = self
        configureUI()
    }
    
    
    private func configureUI() {
        let buttonsCornerRadius: CGFloat  = 15
        hintButton.layer.cornerRadius     = buttonsCornerRadius
        resetButton.layer.cornerRadius    = buttonsCornerRadius
        barHintButton.layer.cornerRadius  = buttonsCornerRadius
        barResetButton.layer.cornerRadius = buttonsCornerRadius
        
        updateViewFromModel()
    }
    
    
    private func updateViewFromModel() {
        if game.hintSetIndices == nil {
            if game.deck.count == 0 {
                game.updateScoreIfMatchOrMismatch()
                presentAlertWithCongratulationsToWinner()
            } else {
                drawThreeMoreCards(self)
            }
        }
        
        updateScoreLabels()
        updateDeckButton()
        updateHintButton()
        
        cardsGridView.grid.frame = cardsGridView.bounds
        cardsGridView.setCells(with: game.cardsOnTable)
        cardsGridView.highlightCards(at: game.selectedCardsIndices, with: glowTypeForSelectedCards)
    }
    
    
    private func updateScoreLabels() {
        if game.secondPlayersTurn {
            firstPlayerScoreLabel.alpha   = 0.5
            secondPlayersScoreLabel.alpha = 1
        } else {
            firstPlayerScoreLabel.alpha   = 1
            secondPlayersScoreLabel.alpha = 0.5
        }
        
        firstPlayerScoreLabel.text   = "⭐️ \(game.score)"
        secondPlayersScoreLabel.text = "⭐️ \(game.secondPlayersScore)"
        deckButton.setTitle("🃏 \(game.deck.count)", for: .normal)
    }
    
    
    private func updateDeckButton() {
        if game.deck.count >= 3 {
            setAppearance(of: deckButton, to: .enabled)
            swipeDownGestureRecognizer.isEnabled = true
        } else {
            setAppearance(of: deckButton, to: .disabled)
            swipeDownGestureRecognizer.isEnabled = false
        }
    }
    
    
    enum ButtonAppearanceType { case enabled, disabled }
    
    private func updateHintButton() {
        let hintButtonAppearance: ButtonAppearanceType =
            (game.hintSetIndices != nil && !game.selectedCardsAreSet)
            ? .enabled
            : .disabled
        
        setAppearance(of: hintButton, to: hintButtonAppearance)
        setAppearance(of: barHintButton, to: hintButtonAppearance)
    }
    
    
    private func setAppearance(of button: UIButton, to appearance: ButtonAppearanceType){
        switch appearance {
        case .enabled:
            button.isEnabled = true
            button.alpha     = 0.8
        case .disabled:
            button.isEnabled = false
            button.alpha     = 0.3
        }
    }
    
    
    //Endgame scenario
    func presentAlertWithCongratulationsToWinner() {
        var winnersName: String
        var winnersScore: Int
        if game.score > game.secondPlayersScore {
            winnersName  = "Player 1"
            winnersScore = game.score
        } else {
            winnersName  = "Player 2"
            winnersScore = game.secondPlayersScore
        }

        let alertController = UIAlertController(title: "Game over!", message: "\(winnersName) won with \(winnersScore) pts.🤯\nCongratulatiuons! 🥳", preferredStyle: .alert)
        
        let forwardAction = UIAlertAction(title: "Rematch!", style: .default) {[weak self] _ in
            guard let self = self else { return }
            alertController.dismiss(animated: true, completion: {
                self.newGameButtonTapped(self)
            })
        }

        alertController.addAction(forwardAction)
        present(alertController, animated: true)
    }
}


extension GameOfSetVC: CardsGridViewDelegate {
    
    func selectCard(at index: Int) {
        game.selectCard(at: index)
        updateViewFromModel()
    }
}
