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
    
    @IBAction func operate(sender: UIButton) {
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
            // if pi where to appear here how would it work?
            // one thought is that it would be multiplied by whatever was the last value entered
            // another is that it would get worked out as a normal number and added to the stack
            // in either case consider the following:
            //  1: if the stack is empty and the user presses pi the value of pi will be entered
            //      in the stack and pi will be displayed aka 3.14159...
            //  2: if the user enters a number like 123 and then presses the pi button will the
            //      current value be multiplied by pi and then added to the stack or will the 
            //      number be added, then pi and then the multiplication button is pressed
            //      (that last bit sounded like a good idea)
            //  3: swift can now call pi by using the following Double.pi, this also applies to 
            //      Float and CGFloat
            
            // for sine and cosine this was a suggestion online:
            // import Foundation
            // var theCosOfZero: Double = Double(cos(0) // should equal 1
            default: break
        }
    }
    
    func performOperation (operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation (operation: Double -> Double) {
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
        print("operandStack = \(operandStack)")
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