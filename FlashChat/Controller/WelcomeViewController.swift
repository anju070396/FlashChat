//
//  ViewController.swift
//  FlashChat
//
//  Created by Anjali on 5/23/20.
//  Copyright © 2020 Anjali. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //typing Animation by CLTypingLabel pod
        self.titleLabel.text =  "⚡️FlashChat"
        self.titleLabel.charInterval = 0.04
        
        
        //typing Animation by loop
//        let title = "⚡️FlashChat"
//        var charIndex = 0.0
//        for letter in title  {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (Timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            charIndex += 1
//        }
    }
    
}

