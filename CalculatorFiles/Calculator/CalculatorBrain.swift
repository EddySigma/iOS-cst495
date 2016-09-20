//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Juan Garcia on 9/13/16.
//  Copyright © 2016 Juan Garcia. All rights reserved.
//

import Foundation // core services

class CalculatorBrain
    // may inherit from msobject
{
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double) // string containing symbol and function that returns a double
        case BinaryOperation(String, (Double, Double) -> Double) // same as above but the function takes two items and still returns a double
    }
    // api aplication programing interface
    
    private var opStack = [Op]() // same as Array<Op>
    
    private var knownOps = [String:Op]() // same as Dictionary<String, Op>()
    
    // initializer
    init() {
        knownOps["×"] = Op.BinaryOperation("×", * )
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["+"] = Op.BinaryOperation("+", + )
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    // the evaluate functions are used recursively where depending on the value of the
    // item in the stack they may look at one item or the entire stack to complete the 
    // the calculations or return an error or a message if it is not possible to return
    // something
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand =  operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
            // there is no break because all cases were taken care of
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        // let (result, remainder) = evaluate(opStack) => here remainder is replaced because we do not care for remainder
        // as it is never used for this function
        let (result, _) = evaluate(opStack)
        return result
    }
    
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate() // is this the best thing to do... for now yes.
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
