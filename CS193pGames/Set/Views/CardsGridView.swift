//
//  CardsGridView.swift
//  Set
//
//  Created by Źmicier Fiedčanka on 10.12.20.
//

import UIKit


protocol CardsGridViewDelegate {
    func selectCard(at index: Int)
}


class CardsGridView: UIView {
    
    var grid                = Grid(layout: .aspectRatio(0.5))
    var presentedCardViews  = [CardView]()
    
    var delegate: CardsGridViewDelegate!
    
    lazy var animator       = UIDynamicAnimator(referenceView: self)
    lazy var cardBehavior   = CardBehavior(in: animator)
    
    lazy var discardPileCenter  = CGPoint(x: self.frame.width * 0.93, y: -30)
    lazy var deckFrame          = CGRect(x: self.bounds.width * 0.95, y: -30, width: 0, height: 0)
    
    override func layoutSubviews() {
        grid.frame = self.bounds
        
        for index in 0..<presentedCardViews.count {
            presentedCardViews[index].frame = grid[index]!
        }
    }
    
    
    //MARK:- Public API
    func setCells(with cards: [Card]) {
        grid.cellCount = cards.count
        
        //Removing views
        var cardViewsToRearrange = [CardView]()
        for cardView in presentedCardViews {
            let viewShouldBeRemoved = cards.filter({ cardView.card == $0 }).isEmpty
            if viewShouldBeRemoved {
                presentedCardViews.remove(at: presentedCardViews.firstIndex(of: cardView)!)
                animateChaoticEscape(for: cardView)
            } else {
                cardViewsToRearrange.append(cardView)
            }
        }
        
        
        //Rearranging views
        presentedCardViews = []
        var currentGridIndex = 0
        for card in cards {
            if let cardView = cardViewsToRearrange.filter({$0.card == card}).first {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: AnimationConstants.rearrangementTime,
                    delay: 0,
                    options: [.curveEaseInOut],
                    animations: { [weak self] in
                        self?.presentedCardViews.insert(cardView, at: currentGridIndex)
                        cardView.frame = (self?.grid[currentGridIndex])!
                    }
                )
                currentGridIndex += 1
            }
        }
        

        //Adding new cardViews
        let newCards = cards.filter({ card in
            return subviews.filter({ ($0 as? CardView)?.card == card }).isEmpty
        })
        
        addCardViews(with: newCards, after: cardViewsToRearrange.count)
    }
    

    func highlightCards(at indices: [Int], with glow: GlowType) {
        for index in presentedCardViews.indices {
            let cardView = presentedCardViews[index]
            
            if indices.contains(index) {
                cardView.glowColor = glow.color
                switch glow {
                case .selected:
                    cardView.isUserInteractionEnabled = true
                case .matched:
                    cardView.isUserInteractionEnabled = false
                case .mismatched:
                    cardView.isUserInteractionEnabled = false
                default: return
                }
            } else {
                cardView.glowColor = GlowType.usual.color
                cardView.isUserInteractionEnabled = true
            }
        }
    }
    
    
    //MARK:- Adding cardViews to grid
    private func addCardViews(with cards: [Card], after offsetIndex: Int) {
        for dealingCardIndex in cards.indices {
            
            //Creating a new CardView instance
            let cardView = CardView(frame: deckFrame, card: cards[dealingCardIndex])
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectCard)))
            cardView.alpha = 0
            addSubview(cardView)
            presentedCardViews.append(cardView)
            
            //Animating flying to correct frame
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: AnimationConstants.totalSpinningTime,
                delay: Double(dealingCardIndex) * AnimationConstants.dealingDelayMultiplier,
                options: [.curveEaseInOut],
                animations: { [self] in
                    cardView.center = CGPoint(x: grid[offsetIndex + dealingCardIndex]!.midX, y: grid[offsetIndex + dealingCardIndex]!.midY)
                    cardView.alpha = 1
                    cardView.transform = CGAffineTransform.identity.scaledBy(x: 10, y: 10)
                }, completion: { _ in
                    UIView.transition(with: cardView, duration: AnimationConstants.cardFlipOverTime, options: [.transitionFlipFromLeft]) {
                        cardView.isFaceUp = true
                    }
                }
            )
            
            //Animating spinning
            for index in stride(from: 0, to: AnimationConstants.numberOfSpins, by: 1)  {
                animateSpin(for: cardView,
                            with: AnimationConstants.singleSpinTime,
                            after: AnimationConstants.dealingDelayMultiplier * Double(dealingCardIndex)
                                + index * AnimationConstants.singleSpinTime)
            }
        }
    }
    
    
    @objc private func selectCard(_ sender: UITapGestureRecognizer) {
        guard let tapIndex = presentedCardViews.firstIndex(of: sender.view as! CardView) else { return }
        delegate.selectCard(at: tapIndex)
    }
    
    
    //MARK:- Animations
    private func animateSpin(for view: UIView, with duration: Double, after delay: Double) {
        let spinPartTime = (duration / 3)
        for spinPartIndex in 0..<3 {
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: spinPartTime,
                delay: delay + Double(spinPartIndex) * spinPartTime,
                options: [.curveLinear],
                animations: {
                    view.transform = CGAffineTransform.identity.rotated(
                        by: ((2 * CGFloat.pi) / 3) * CGFloat(spinPartIndex + 1)
                    )
                }
            )
        }
    }
    
    
    private func animateChaoticEscape(for view: CardView) {
        bringSubviewToFront(view)
        cardBehavior.addItem(view)
        
        Timer.scheduledTimer(withTimeInterval: AnimationConstants.chaoticBouncingTime, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            self.cardBehavior.removeItem(view)
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: AnimationConstants.cardEscapeTime,
                delay: 0,
                options: [.curveEaseInOut],
                animations: { view.center = self.discardPileCenter },
                completion: { _ in
                    UIView.transition(
                        with: view,
                        duration: AnimationConstants.cardFlipOverTime,
                        options: [.transitionFlipFromRight],
                        animations: {
                            view.isFaceUp = false
                        },
                        completion: { _ in view.removeFromSuperview() }
                    )
                }
            )
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: AnimationConstants.cardEscapeTime,
                delay: 0,
                options: [.curveLinear],
                animations: {
                    view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                }
            )
        }
    }
}
