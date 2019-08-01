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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
    }


}

