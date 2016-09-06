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
    
    var userIsInTheMiddleOfTypingNumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        // declare a local var
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    // internal stack that contains the numbers
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        operandStack.append(newElement: T)
    }
}