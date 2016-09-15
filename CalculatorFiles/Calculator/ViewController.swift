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
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "Sin": performOperation { sin($0) }
        case "Cos": performOperation { cos($0) }
        default: break
        }
    }
    
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
    }
    
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
    }
    
    // internal stack that contains the numbers
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        if usingRadixPoint {
            usingRadixPoint = false
        }
        print("operandStack = \(operandStack)")
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
