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
    @IBOutlet weak var equation: UILabel!
    
    var userIsInTheMiddleOfTypingANumber : Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func pi(sender: AnyObject) {
        // user is in the middle of typing a number
        // not in the middle of typing a number
        print ("hello: pi not finished")
    }
    
    @IBAction func addDot() {
        let dot: Character = "."
        if !display.text!.characters.contains(dot) {
            display.text = display.text! + "."
        }
    }
    
    @IBAction func changePolarity() {
        if (display.text! as NSString).doubleValue > 0{
            display.text = "-" + display.text!
        } else if (display.text! as NSString).doubleValue < 0 {
            display.text = String(display.text!.characters.dropFirst())
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                clear()
                displayValue = nil
            }
        }
    }

    //var operandStack = Array<Double>()
    
    
    @IBAction func clear() {
        display.text = "0"
        brain.clearStack()
        brain.clearVariables()
        equation.text = " "
    }
    
    @IBAction func enter() {
        print(userIsInTheMiddleOfTypingANumber)
        equation.text = equationDisplay
        userIsInTheMiddleOfTypingANumber = false;
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        }
    }
    
    @IBAction func backspace() {
        // func 1: delete a number from display
        if display.text!.characters.count > 1 {
            if display.text! == "nil" {
                display.text = "00" // why is 00 needed to display a single 0
            }
            display.text = display.text!.substringToIndex(display.text!.endIndex.predecessor())
        }// func 2: undo a change (aka. remove item from stack)
        else {
            // set the display to 0
            display.text = "0"
            // check the length of items in the opStack in the brain...
            // remove a item if count >0 else do nothing
        }
    }
    
    
    var displayValue: Double! {
        get {
            return ( NSNumberFormatter().numberFromString(display.text! as String)!.doubleValue )
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
//    @IBAction func pushVariable() {
//        print("hello: pushVariable not finished")
//    }
//    
//    @IBAction func inputVariable() {
//        print("hello: inputVariable not finished")
//    }
    
    var equationDisplay: String {
        get {
            return "\(brain)"
        }
    }
}