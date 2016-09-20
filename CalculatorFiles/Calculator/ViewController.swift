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

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingNumber = false
    var brain = CalculatorBrain()
    var usingRadixPoint = false
    
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
    
    @IBAction func radixPoint() {
        if userIsInTheMiddleOfTypingNumber {
            if !usingRadixPoint {
                display.text = display.text! + "."
            }
        } else {
            if !usingRadixPoint{
                display.text = "0."
            }
            userIsInTheMiddleOfTypingNumber = true
        }
        usingRadixPoint = true
    }
        
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0 // you want to give the capacity of taking nils. For hw
            }
        }
        
    }
    
    // pi and radix most be updated to acomodate the new calculatorBrain
    /*
    @IBAction func pi() {
        if display.text == "0" {
            display.text = "\(M_PI)"
            enter()
        }
        else {
            enter()
            operandStack.append(M_PI)
            performOperation { $0 * $1 }
        }
    }*/
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
        /* previous message applies here too
        if usingRadixPoint {
            usingRadixPoint = false
        }*/
    }
    
    // computed property example
    var displayValue: Double {
        get {
            // figure out what goes here
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }
}
