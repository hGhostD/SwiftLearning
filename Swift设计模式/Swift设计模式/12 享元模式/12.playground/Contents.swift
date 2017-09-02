//: Playground - noun: a place where people can play

import Cocoa

///享元模式可以在多个调用组件之间共享数据

let num1 = NSNumber(integerLiteral: 10)
let num2 = NSNumber(integerLiteral: 10)

print(num1 == num2)
print(num1 === num2)
