//
//  ViewController.swift
//  Concentration
//
//  Created by Źmicier Fiedčanka on 4.12.20.
//

import UIKit

class ConcentrationVC: UIViewController {
    
    // MARK: - Key parameters
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var theme: Theme! {
        didSet {
            //That line is crucial because it's causing outlets to init (and therefore app doesn't crash trying to access force-unwrapped scoreLabel etc. Looks error-prone though
            view.backgroundColor            = theme.backgroudColor
            title = "\(theme.name) Concentration"
            
            scoreLabel.textColor            = theme.cardBackColor
            newGameButton.backgroundColor   = theme.cardBackColor
            newGameButton.setTitleColor(theme.backgroudColor, for: .normal)
            cardBackColor = theme.cardBackColor
            
            emojiChoices = theme.emojiChoices
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    
    // MARK: - Supporting parameters
    private var cardBackColor: UIColor!
    private var emojiChoices: String!
    private var emoji: [ConcentrationCard: String]!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    
    var numberOfPairsOfCards: Int { (visibleCardButtons.count + 1) / 2 }
    
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        for button in cardButtons {
            button.layer.cornerRadius = 8
        }
        newGameButton.layer.cornerRadius = 12
        
        
        if theme == nil {
            theme = Theme.samples.randomElement()
        } 
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        scoreLabel.text = traitCollection.verticalSizeClass == .compact ? "Score\n\(game.score)" : "Score: \(game.score)"
    }

    // MARK: - IBActions
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = visibleCardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            
            if game.gameIsOver {
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] timer in
                    guard let self = self else { return }
                    self.newGameButtonTouched(timer)
                }
            }
        }
    }
    
    
    @IBAction private func newGameButtonTouched(_ sender: Any) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emojiChoices = theme.emojiChoices
        emoji = [:]
        updateViewFromModel()
    }
    

    // MARK: - Dealing with UI
    private func updateViewFromModel() {
        for index in visibleCardButtons.indices {
            updateAppearance(for: visibleCardButtons[index], with: game.cards[index])
        }
        
        scoreLabel.text = (traitCollection.verticalSizeClass == .compact)
            ? "Score\n\(game.score)"
            : "Score: \(game.score)"
    }
    
    
    private func updateAppearance(for button: UIButton, with card: ConcentrationCard) {
        var newTitle: String
        var newColor: UIColor
        
        if card.isFaceUp {
            newTitle = emoji(for: card)
            newColor = cardBackColor.withAlphaComponent(0.5)
        } else {
            newTitle = ""
            newColor = card.isMatched ? .clear : cardBackColor
        }
        
        let action = {
            button.setTitle(newTitle, for: .normal)
            button.backgroundColor = newColor
            button.isEnabled = !card.isFaceUp && !card.isMatched
        }
        
        if newTitle != button.currentTitle {
            var options: UIView.AnimationOptions
            switch newColor {
            case .clear:
                options = .transitionCrossDissolve
            case cardBackColor:
                options = .transitionFlipFromRight
            case cardBackColor.withAlphaComponent(0.5):
                options = .transitionFlipFromLeft
            default: options = []
            }
            
            UIView.transition(with: button, duration: 0.6, options: options) { action() }
        } else {
            action()
        }
    }
    
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emojiChoices.count > 0, emoji[card] == nil {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
}
