//
//  ViewController.swift
//  Calculator
//
//  Created by Juan Garcia on 9/2/16.
//  Copyright © 2016 Juan Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        // declare a local var
        let digit = sender.currentTitle
        print("digit = \(digit)")
    }
}