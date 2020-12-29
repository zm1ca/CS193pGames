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
            let button  = visibleCardButtons[index]
            let card    = game.cards[index]
            if card.isFaceUp {
//                let padding: CGFloat = 10
//                let fontSize = min(button.frame.width, button.frame.height) - padding * 2
//                button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = cardBackColor.withAlphaComponent(0.5) // I need lighter color, not transparent
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : cardBackColor
            }
            
            button.isEnabled = !card.isFaceUp && !card.isMatched
        }
        scoreLabel.text = traitCollection.verticalSizeClass == .compact ? "Score\n\(game.score)" : "Score: \(game.score)"
    }
    
    
    private func emoji(for card: ConcentrationCard) -> String {
        if emojiChoices.count > 0, emoji[card] == nil {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
}
