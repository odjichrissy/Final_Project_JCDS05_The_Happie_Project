//
//  ViewController.swift
//  Happie
//
//  Created by Chrissy Satyananda on 08/07/19.
//  Copyright © 2019 Odjichrissy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var welcomeTextView: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    let dailyQuotes = QuoteBanks()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 10
        
//        let quoteRandom = Int.random(in: 1..<dailyQuotes.list.count)
//        welcomeTextView.text = dailyQuotes.list[quoteRandom].quoteText
//        welcomeTextView.text = """
//        The Happie Project is a system which
//        predict the level of individual
//        happiness based on the variety of
//        life aspects
//        """
        
    }
    
    
}

