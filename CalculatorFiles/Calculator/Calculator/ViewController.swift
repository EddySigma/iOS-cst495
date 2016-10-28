//
//  ViewController.swift
//  Calculator
//
//  Created by Juan Eduardo Garcia on 10/15/16.
//  Copyright © 2016 Juan Eduardo Garcia. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var userInput: UILabel!
    
    var userIsInTheMiddleOfTypingANumber : Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func addDot() {
        let dot: Character = "."
        if !display.text!.characters.contains(dot) {
            display.text = display.text! + "."
        }
    }
    
    @IBAction func clear() {
        // stack should be emptied
        operandStack.removeAll()
        // userActionStack should be empty
        userActionStack.removeAll()
        // display should be zero
        display.text = "0"
        // userInput should be empty
        userInput.text = " "
        print("operandStack = \(operandStack)")
    }
    
    @IBAction func backspace() {
        if operandStack.count > 0 {
            operandStack.removeLast()
        }
        print("operandStack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        userActionStack.append(operation)
        
        // for swtiches you need to cover every possible outcome
        switch operation {
            // multiplication
        case "×": performOperation { $0 * $1 }
            // division
        case "÷": performOperation { $1 / $0 }
            // addition
        case "+": performOperation { $0 + $1 }
            // subtraction
        case "−": performOperation { $1 - $0 }
            // square root
        case "√": performOperation { sqrt($0) }
            // sin
        case "Sin": performOperation { sin($0) }
            // cos
        case "Cos": performOperation { cos($0) }
            
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
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
    
    @IBAction func pi() { // not fully functional
        let number = M_PI
        if userIsInTheMiddleOfTypingANumber {
            enter()
            display.text = "\(number)"
        }
        display.text = "\(number)"
    }
    
    var operandStack = Array<Double>()
    var userActionStack = Array<String>()
    
    
    @IBAction func enter() {
        // add numbers to the internal stack
        
        userIsInTheMiddleOfTypingANumber = false;
        userActionStack.append("\(displayValue)")
        operandStack.append(displayValue)
        userInput.text = userInputs
        print("operandStack = \(operandStack)")
    }
    
    // computed properties
    var displayValue: Double {
        // instead of initializing this variable to an actual value we can make it so that
        // the value that corresponds to the variable is calculated before it is set.
        get {
            // here we compute the value
            // print(display.text!)
            return (NSNumberFormatter().numberFromString(display.text! as String)!.doubleValue)
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
//    func convertDoubleArrayToStrings (initialAr: Array<Double>) -> Array<String>  {
//        return initialAr.flatMap{ String($0) }
//    }
    
    var userInputs: String {
        get {
            return userActionStack.joinWithSeparator(", ")
        }
        set {
            userInput.text = "\(newValue)"
        }
    }
}