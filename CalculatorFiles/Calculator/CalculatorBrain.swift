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
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
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
    
    func evaluate(ops: [Op]) -> (result: Double?, remaining: [Op])
    {
        var ops = ops
        if !0ps.isEmpty {
            let op = ops.removeLast()
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        
    }
    
    
    func pushOperand(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func performOperation(symbol: String){
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
    }
}
