//
//  ViewController.swift
//  PlayingCard
//
//  Created by Yi Xuan Qi on 2019-07-30.
//  Copyright © 2019 Yi Xuan Qi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
//    @IBOutlet weak var playingCardView: PlayingCardView!{
//        didSet{
//            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
//            swipe.direction = [.left,.right]
//            playingCardView.addGestureRecognizer(swipe)
//            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
//            playingCardView.addGestureRecognizer(pinch)
//        }
//    }
//
//    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
//        switch sender.state {
//        case .ended:
//            playingCardView.isFaceUp = !playingCardView.isFaceUp
//        default:
//            break
//        }
//    }
//
//
//    @objc func nextCard(){
//        if let card = deck.draw(){
//            playingCardView.rank = card.rank.order
//            playingCardView.suit = card.suit.description
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        for _ in 1...10 {
//            if let card = deck.draw() {
//                print("\(card)")
//            }
//        }
//    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 1 ... ((cardViews.count+1)/2){
            let card = deck.draw()!
            cards += [card,card]
        }
        for cardView in cardViews{
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
        }
    }
    
    private var faceUpCards : [PlayingCardView] {
        return cardViews.filter {$0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1}
    }
    
    private var faceUpCardViesMatch : Bool {
        return faceUpCards.count == 2 && faceUpCards[0].rank == faceUpCards[1].rank && faceUpCards[0].suit == faceUpCards[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state {
                    case .ended:
                        if let playingCardView = recognizer.view as? PlayingCardView, faceUpCards.count < 2 {
                            lastChosenCardView = playingCardView
                            cardBehavior.removeItem(playingCardView)
                            UIView.transition(with: playingCardView,
                                              duration: 0.5,
                                              options: [.transitionFlipFromLeft],
                                              animations: {
                                              playingCardView.isFaceUp = !playingCardView.isFaceUp},
                                              completion: { finished in
                                                let cardsToAnimate = self.faceUpCards
                                                if self.faceUpCardViesMatch {
                                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                                    withDuration: 0.5,
                                                    delay: 0,
                                                    options: [],
                                                    animations: {
                                                        cardsToAnimate.forEach {
                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                            }
                                                        },
                                                    completion:  { position in
                                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                                            withDuration: 0.65,
                                                            delay: 0,
                                                            options: [],
                                                            animations: {
                                                                cardsToAnimate.forEach {
                                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                                    $0.alpha = 0
                                                                }
                                                            },
                                                            completion: { position in
                                                                cardsToAnimate.forEach{
                                                                    $0.isHidden = true
                                                                    $0.alpha = 1
                                                                    $0.transform = .identity
                                                                }
                                                                
                                                            }
                                                        )
                                                    }
                                                    )
                                                } else if self.faceUpCards.count == 2 {
                                                    if playingCardView == self.lastChosenCardView{
                                                    self.faceUpCards.forEach {cardView in
                                                        UIView.transition(with: cardView,
                                                                          duration: 0.5,
                                                                          options: [.transitionFlipFromLeft],
                                                                          animations: {
                                                                          cardView.isFaceUp = false},
                                                                          completion: {finished in
                                                                            self.cardBehavior.addItem(cardView)
                                                                            
                                                                }
                                                            )
                                                        }
                                                    }
                                                } else {
                                                    if !playingCardView.isFaceUp {
                                                        self.cardBehavior.addItem(playingCardView)
                                                    }
                                                }
                                }
                            )
                        }
                    default:
                        break
                    }
    }

}

extension CGFloat{
    var arc4random: CGFloat{
        if self>0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -1*CGFloat(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

