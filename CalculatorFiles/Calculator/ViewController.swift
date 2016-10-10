//
//  ViewController.swift
//  Calculator
//
//  Created by Juan Garcia on 9/2/16.
//  Copyright © 2016 Juan Garcia. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel?
    
    var userIsInTheMiddleOfTypingNumber = false
    var brain = CalculatorBrain()
    var usingRadixPoint = false
    
    @IBAction func appendDigit(_ sender: UIButton) {
        // declare a local var
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            display?.text = (display?.text!)! + digit
        } else {
            if digit != "\(0)" {
                display?.text = digit
                userIsInTheMiddleOfTypingNumber = true
            }
        }
    }
    
    @IBAction func radixPoint() {
        if !usingRadixPoint {
            display?.text = (display?.text!)! + "."
            usingRadixPoint = true
            userIsInTheMiddleOfTypingNumber = true
        }
    }
        
    @IBAction func operate(_ sender: UIButton) {
        //let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(symbol: operation) {
                displayValue = result
            } else {
                displayValue = nil // you want the capacity to take nils -> done!!!
            }
        }
    }
    
    @IBAction func pi() {
        if !userIsInTheMiddleOfTypingNumber {
            display?.text = "\(M_PI)"
            enter()
        }
        else {
            enter()
            display?.text = "\(M_PI)"
            enter()
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    @IBAction func clear() {
        // call brain.wash()
        display?.text = "\(0)"
        userIsInTheMiddleOfTypingNumber = false
        usingRadixPoint = false
    }
    
    // the stack has been moved to calculator brain
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        if let result = brain.pushOperand(operand: displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    // computed property example
    var displayValue: Double? {
        get {
            // figure out what goes here
            return NumberFormatter().number(from: (display?.text!)!)!.doubleValue
        }
        set {
            if newValue != nil {
                display?.text = "\(newValue!)"
            } else {
                display?.text = "---Error---"
            }
            
            userIsInTheMiddleOfTypingNumber = false
        }
    }
}
