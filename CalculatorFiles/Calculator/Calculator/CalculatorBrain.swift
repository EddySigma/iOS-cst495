//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Juan Garcia on 10/18/16.
//  Copyright © 2016 Juan Eduardo Garcia. All rights reserved.
//

// this is the model

// note: make things private if they are not needed by a user
// public if making framework that someone will use
// private -> only accesible by this object

// --==--== --==--== --==--== --==--== --==--== --==--== --==--== Stopped video 3 @ 1:06:10 ==--==-- ==--==-- ==--==-- ==--==-- ==--==-- ==--==-- ==--==-- // also opStack is displaying junk


import Foundation

class CalculatorBrain {
    // data structure
    // op could be an operand or operation
    private enum Op: CustomStringConvertible {  // Printable was replaced by CustomStringConvertible -> also this implements a protocol
                                                // meaning that what is in that protocol has been made here as well... explained later
        // no inheritance
        // only computed properties
        // good for whend something needs to be one thing one time and another at another time (never both)
        case Operand(Double)
        case UnaryOperation(String, Double -> Double) // takes a string and a function that takes a double and returns a double
        case BinaryOperation(String, (Double, Double) -> Double)
        // swift has the capability to assossiate data with the cases in the enum
        // api: application programming interface -> methods and properties that make up your class
        
        // computed property to print the data in this Op
        var description: String {   // this allows the array to be printed one item at a time (since our array is made up of Op objects
            get{                    // we have to specify how to print these Op objects using a switch
                switch self {
                case .Operand (let operand):
                    return "\(operand)" // here we only return the number
                case .UnaryOperation (let symbol, _): // we do not care about anything other than the string (string contains +, ÷, × etc)
                    return symbol       // returning the op -> operation symbol
                case .BinaryOperation (let symbol, _):
                    return symbol       // same as above...
                }
            }
            // set {
            //      removing this section makes the property a read only property
            // }
        }
        
    }
    
    // var opStack = Array<Op>() // simple and clear, not prefered
    private var opStack = [Op]() // prefered notation (also prefered to be private because its type is private and we dont want other obj.s messing with it)
    
    // this is a dictionary
    // var knownOps = Dictionary<String, Op>() // not prefered
    private var knownOps = [String:Op]() // prefered (may want in the future to make it public to allow someone else to teach it new ops -> for now it has to be private)
    
    // my first initializer -> aka constructor
    init() {
        // you are allowed to make functions inside functions especialy if they are just used inside their respective functions
        func learnOp( op: Op) {  // this function will help fix the problem of repeating symbols in the following few lines
                                // exa: knownOps["×"] = Op.BinaryOperation("×", * )
            knownOps[op.description] = op // this line makes so the description is set to whatever is put in the function learn op
        }
        
        // the following replaces the old code bellow it (commented out)
        
        // binary
        learnOp( Op.BinaryOperation("×", * ) )
        learnOp( Op.BinaryOperation("÷", { $1 / $0 }) )
        learnOp( Op.BinaryOperation("+", + ) )
        learnOp( Op.BinaryOperation("−", { $1 - $0 }) )
        
        // unary
        learnOp( Op.UnaryOperation("√", sqrt) )
        
        ////        knownOps["×"] = Op.BinaryOperation("×", { $0 * $1 })
        //        knownOps["×"] = Op.BinaryOperation("×", * ) // just like in square root this is a function that takes parameters and returns double (in this case two doubles)
        //        // the reason both division and subtraction do not work like multiplication and addition is because the order of the values matters in this cases and it is necesary to specify
        //        knownOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 })
        //        knownOps["+"] = Op.BinaryOperation("+", + )
        //        knownOps["−"] = Op.BinaryOperation("−", { $1 - $0 })
        //        
        ////        knownOps["√"] = Op.UnaryOperation("√", { sqrt($0) }) // this line is not the best way to do it
        //        knownOps["√"] = Op.UnaryOperation("√", sqrt) // because this is a function that takes a value and returns a value (just like we want)
    }
    
    
    // arrays and dictionarys are not classes, and classes are pass by value. Arrays and dictionarys are strucs (structures almost the same as classes)
    // diff between strucs and classes are classes inherit, structs are passed by value.  Note: even doubles and ints are structs.
    
    // in the following evaluate there is an implicit let for ops making it read only -> cant make changes to it
        // changing the implicit let into a var will make it so that the copy will be mutable but it still is a copy
    // unnamed tuple ->(Double!, [Op]) // this still works in the following, but adding names is very helpfull
    private func evaluate( ops: [Op]) -> (result: Double?, remainingOps: [Op]) { // tuple with names -> good for readability.
        // tuple, make like a pseudo object -> (kind of a list in here) // can be more than two items
        // tuple can be used for return
        
        if !ops.isEmpty { // check that the stack is not empty
            var remainingOps = ops // this makes it a copy (use of =) // also a copy is not really made until needed
            // let op = ops.removeLast() -> error: can' remove last from an immutable object
            // let op = ops.removeLast() // thanks to the changes made to ops on the function header and the remainingOps variable
            let op = remainingOps.removeLast() // added note all arguments have the hiden let
            
            switch op {
            case .Operand(let operand): // here let can be replaced with var, but almost always you dont want that.
                // .Operand refers to Op.Operand -> this is how enums are handled
                // ( in here ) asks for what you want to do with the associated value that you get for handling this case
                //      where the enum Op is operand...
                // let the associated value be assigned to operand -> statement in parentesis   (let operand)
                
                return (operand, remainingOps)
                // the statement above returns the current operand and the remaining items in the stack
            case .UnaryOperation(_, let operation): // in this case the first item is the symbol and we do not case for it,this item
                                                    // (the expected string) will be replaced by _ which means ignore, in the other
                                                    // hand we do care about the math operation, thus we store it in operation
                let operandEvaluation = evaluate(remainingOps) // recursively make a call to check the rest of the items in the stack
                if let operand = operandEvaluation.result {// line above is a tuple and here we only want the outcome... store as operand
                // the operand above is an optional double -> also the if let ... allows operand to be double (or checks that it is one)
                    return (operation(operand), operandEvaluation.remainingOps)
                    // the above returns the operand and the items leftover in the stack after the recursion
                }
            case .BinaryOperation(_, let operation): // again we do not care about the first part
                // in here we will do the same as in the unaryoperation case but twice instead because there are two items checked from
                // the stack instead of one.
                let op1Evaluation = evaluate(remainingOps) // recurse once
                if let operand1 = op1Evaluation.result {    // make the outcome of the previus a double
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps) // recurse again for the next item in the stack
                    if let operand2 = op2Evaluation.result { // also make it a double
                        return(  operation(operand1, operand2), op2Evaluation.remainingOps)
                        // in the line above we return the operation containing the two operands found and the remaining of the stack
                    }
                }
            // default: breack -> this line is not necesary because all the possible cases have been taken care of :)
            }
        }
        return (nil, ops) // failure or default -> can't be evaluated
        
    }
    
    func evaluate() -> Double? { // return optional -> can't evaluate things like "+" alone... this is important, may need to return a nil in this situation
        // advise -> recursion ahead...
        
        
        // example evaluate the stack (x, 4, +, 5, 6):
        
            // helper that checks a stack -> evaluates the top (may need to look at everything in the stack)
            // 1st -> x              stack: (4, +, 5, 6)   (calls itself again because "x" needs two operands)
            // 2nd -> 4 X            stack: (+, 5, 6)      (four is found and returns it, but it still needs another number, so it makes the call again this time for the next value needed to multiply)
            // 3rd -> 4 x ( + )      stack: (5, 6)         (plus ("+" note: the parentesis are for human help, the program did not make those) is found and we make a recursive call to find the operands needed, this time for addition)
            // 4th -> 4 x ( 5 + )    stack: (6)            (five is found, then the next number is needed for the addition)
            // 5th -> 4 x ( 5 + 6 )  stack: ()             (six is found, the addition can be computed, thus returning the operand needed for mutiplication. Which in turn returns the outcome of that number and four)
        let (result, remainder) = evaluate(opStack)
        // the line above makes a call to the other function that will take care of all the work previously described and the outcome
        // will be stored in the tuple (result, remainder)
        
        print("\(opStack) = \(result) with \(remainder) left over")
        
        return result
    }
    
    
    func pushOperand(operand: Double) -> Double? { // public
        // making an enum: Op.Operand(operand)
        opStack.append(Op.Operand(operand))
        return evaluate() // every time you push an operand it will return the evaluation
    }
    
    func performOperation(symbol: String) -> Double? { // public
        // the brackets in the following line are the way that we search things in a dictionary
        if let operation = knownOps[symbol] { // the reason this is an optional op (Op?) is because you may be searching for something that is not there -> thus nil will be returned
            opStack.append(operation) // if it can be found in known operations add it to the opStack
        }
        return evaluate()
    }
}