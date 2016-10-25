//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Juan Garcia on 10/18/16.
//  Copyright © 2016 Juan Eduardo Garcia. All rights reserved.
//

import Foundation

class CalculatorBrain: CustomStringConvertible {
    // fair game
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)

        
        // description
        var description: String {
            get{
                switch self {
                case .Operand (let operand):
                    return "\(operand)"
                case .UnaryOperation (let symbol, _):
                    return symbol
                case .BinaryOperation (let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
        
    }
    
    // fair
    private var opStack = [Op]()
    
    // fair
    private var knownOps = [String:Op]()
    init() {
        func learnOp( op: Op) {
            knownOps[op.description] = op
        }
        // binary
        learnOp( Op.BinaryOperation("×", * ) )
        learnOp( Op.BinaryOperation("÷", { $1 / $0 }) )
        learnOp( Op.BinaryOperation("+", + ) )
        learnOp( Op.BinaryOperation("−", { $1 - $0 }) )
        // unary
        learnOp( Op.UnaryOperation("√", sqrt) )
        learnOp( Op.UnaryOperation("Cos", cos) )
        learnOp( Op.UnaryOperation("Sin", sin) )
    }
    
    // fair
    private func evaluate( ops: [Op] ) -> (result: Double!, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .Variable(let symbol):
                return (variableValues[symbol]!, remainingOps)
                
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
    
    func evaluate() -> Double! {
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
    
    // clearing functions
    func clearStack() {
        opStack.removeAll()
    }
    
    func clearVariables() {
        variableValues.removeAll()
    }
    
    // overloaded function for variable pushing
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    var variableValues = [String: Double]() // storage for the variables
    
    private func writeEquation(remaining: [Op]) -> (equation: String, [Op]) {
        
        if !remaining.isEmpty {
            var leftOver = remaining // items left in stack
            let op = leftOver.removeLast() // grab the last one
            print(op)
            var answer = ""
            
            switch op {
            case .Operand(let operand):
                if leftOver.count > 0 {
                    answer = String(operand) + "," + writeEquation(leftOver).equation
                    return ( answer, leftOver )
                } else {
                    answer = String(operand)
                    return ( answer, leftOver )
                }
            
            case .Variable(let symbol):
                if leftOver.count > 0 {
                    answer = symbol + "," + writeEquation(leftOver).equation
                    return ( answer, leftOver )
                } else {
                    answer = symbol
                    return ( answer, leftOver )
                }
            
            case .UnaryOperation(let symbol, _):
                let equationSection = writeEquation(leftOver)
                answer = symbol + "(" + equationSection.equation + ")"
                
                //let operand = equationSection.equation
                //answer = operand + symbol
                return ( answer, leftOver )
                
            case .BinaryOperation(_, let operation):
                return ("", leftOver)
//                let op1Evaluation = evaluate(remainingOps)
//                if let operand1 = op1Evaluation.result {
//                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
//                    if let operand2 = op2Evaluation.result {
//                        return(  operation(operand1, operand2), op2Evaluation.remainingOps)
//                    }
//                }
            }
        }
        return ("", remaining)
    }

    var description: String {
        get{
            let (equation, _) = writeEquation(opStack)
            return equation
        }
    }
}