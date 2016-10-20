//
//  ViewController.swift
//  Calculator
//
//  Created by Juan Eduardo Garcia on 10/15/16.
//  Copyright © 2016 Juan Eduardo Garcia. All rights reserved.
//
//      Note: this is a remake of the original program. This is because the previous version
//          was updated using Xcode 8 this caused some problems in the code and may cause more
//          of them in the future.

import UIKit
import Foundation

class ViewController: UIViewController {
    
    // why is the following not initialized??? -> because it is an optional and
    //      they are always initialized to nil
    @IBOutlet weak var display: UILabel!
    
    // in the following var there is an error because it is not initialized.
    //      in swift all properties have to be initialized when the object is
    //      initialized
    var userIsInTheMiddleOfTypingANumber : Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        //local variable
        // let = constant
        
        // currentTitle gets the title of the button
        let digit = sender.currentTitle!
        // digit is an optional string this means that it is an optional that can be a string
        //   not the other way around (because .currentTitle returns an optional string)
        // printing >>>> print("digit = \(digit)")
        
        // optionals >>>> ? -> unwrap for now, ! -> automaticaly unwrap (implicitely unwraped optional)
        // program will crash if the optional is set to nil
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
            
            // this is meant so that when the user enters one of the operands there will not be a need to 
            // enter the enter button. This will make things easier for the user
        }
        
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
        case "√": performOperation { sqrt($0) }
            
        default: break
        }
    }
    
    // the following function will takes an operation that takes two doubles and returns one
    // operation has a type as defined by us that is two doubles that return a double
    private func performOperation(operation: (Double, Double) -> Double) {
        // the if statement is meant as protection in case there are not enough
        // values in the array to complete the calculation
        if operandStack.count >= 2 {
            
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            // the reason for the enter is the same as in operate we want to make things easy
            // for the user. So we want them to press a operation button tha will result in a outcome
            // and subsequent presses will do the same without the need of more actions by the user
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
    //var operandStack: Array<Double> = Array<Double>() // empty array
    var operandStack = Array<Double>() // infered version
    
    
    @IBAction func enter() {
        // add numbers to the internal stack
        
        userIsInTheMiddleOfTypingANumber = false;
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    // computed properties
    var displayValue: Double {
        // instead of initializing this variable to an actual value we can make it so that
        // the value that corresponds to the variable is calculated before it is set.
        get {
            // here we compute the value
            print(display.text!)
            return (NSNumberFormatter().numberFromString(display.text! as String)!.doubleValue)
        }
        set {
            // code that takes the value the variable was set to and actualy sets it? -it was not clear...
            
            // whenever the value of displayValue is set newValue will be set to such... (magic?)
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            // this is set false because if the value in displayValue is set we no longer need to display it
        }
    }
}