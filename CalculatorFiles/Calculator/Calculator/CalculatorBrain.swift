//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Juan Garcia on 10/18/16.
//  Copyright © 2016 Juan Eduardo Garcia. All rights reserved.
//



// --==--== --==--== --==--== --==--== --==--== --==--== --==--== Lecture 5 (stopped @ 32:50) ==--==-- ==--==-- ==--==-- ==--==-- ==--==-- ==--==-- ==--==-- //


import Foundation

class CalculatorBrain {
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self {
                case .Operand (let operand):
                    return "\(operand)"
                case .UnaryOperation (let symbol, _):
                    return symbol
                case .BinaryOperation (let symbol, _):
                    return symbol
                }
            }
        }
        
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp( op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp( Op.BinaryOperation("×", * ) )
        learnOp( Op.BinaryOperation("÷", { $1 / $0 }) )
        learnOp( Op.BinaryOperation("+", + ) )
        learnOp( Op.BinaryOperation("−", { $1 - $0 }) )
        
        learnOp( Op.UnaryOperation("√", sqrt) )
    }
    
    // add the following section for assig3 ===================================================================================== //
    typealias PropertyList = AnyObject // makes a made up type equal an existing type -> good for documentation
    
    var program: PropertyList { // guaranteed to be a PropertyList
        // get takes original value and modifies it... to store it in this instance
        get {
            // get property list representation from the data structure
            // 1st way
//            var returnValue = Array<String>()
//            for op in opStack {
//                returnValue.append(op.description)
//            }
//            return returnValue
            
            // 2nd more clever way
            print(opStack.map { $0.description })
            return opStack.map { $0.description }
            // note from swift Array has a function .map(closure) // where closure is called per each item in the array and
            // returns an alternative mapped value for that item. The mapping and style depend on the closure itself.
        }
        // set takes the stored value and returns it in a way that can be interpreted... this case is our data Structure
        set {
            // take the property list and turn it back into the data structure representation
                // newValue is an AnyObject
            if let opSymbols = newValue as? Array<String> { // as? is used to ensure that Arran<String> is returned
                var newOpStack = [Op]() // make newOpStack to store the contents of the array
                for opSymbol in opSymbols { // iterate through every item in the array
                    if let op = knownOps[opSymbol] { // if the item is a knownOp then add it to the stack
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        // if the item is not an knownOp then it is a number... convert it to a double
                        newOpStack.append(.Operand(operand)) // the number is stored in the stack
                    }
                    // optional chaining if at any point an item returns nil, the entire expresion returns nil
                    // this is why the ? is used. If opSymbol is nil, numberFromString does not understand what to do 
                    // with it and returns nil... and so on.
                }
            }
        }
    }
    // add the previous section for assig3 ===================================================================================== //
    
    private func evaluate( ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return(  operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
        
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        
        print("\(opStack) = \(result) with \(remainder) left over")
        
        return result
    }
    
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}