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

class ViewController: UIViewController {
    
    // why is the following not initialized???
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
        
        // optionals >>>> ? -> unwrap now, ! -> permanently unwrap
        // program will crash if the optional is set to nil
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

}