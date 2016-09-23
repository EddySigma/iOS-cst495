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
    
    @IBAction func appendDigit(_ sender: UIButton) {
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
        
    @IBAction func operate(_ sender: UIButton) {
        //let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(symbol: operation) {
                displayValue = result
            } else {
                displayValue = 0 // you want the capacity to take nils
            }
        }
    }
    
    @IBAction func pi() {
        /*
        if display.text == "0" {
            display.text = "\(M_PI)"
            enter()
        }
        else {
            enter()
            operandStack.append(M_PI)
            performOperation { $0 * $1 }
        }*/
    }
    /*
    func performOperation (_ operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    fileprivate func performOperation (_ operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }*/
    
    // the stack has been moved to calculator brain
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        /*if usingRadixPoint {
            usingRadixPoint = false
        }
        print("operandStack = \(operandStack)")*/
        if let result = brain.pushOperand(operand: displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    // computed property example
    var displayValue: Double {
        get {
            // figure out what goes here
            return NumberFormatter().number(from: display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }
}
