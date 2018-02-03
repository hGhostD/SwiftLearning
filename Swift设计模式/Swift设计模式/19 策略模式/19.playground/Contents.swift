import Cocoa
/*:
 > 策略模式通过让一组算法对象遵循一个定义明确的协议的,使得我们可以在不修改原有类的情况下拓展其功能
*/
//定义一个协议
protocol Strategy {
    func execute(value:[Int]) -> Int
}

class SumStrategy: Strategy {
    func execute(value: [Int]) -> Int {
        return value.reduce(0) { x,y in x + y }
    }
}
class MultiplyStrategy: Strategy {
    func execute(value: [Int]) -> Int {
        return value.reduce(0) { x,y in x * y }
    }
}

final class Sequence {
    private var numbers:[Int]
    
    init(_ numbers: [Int]) {
        self.numbers = numbers
    }
    
    func addNumeber(value: Int) {
        self.numbers.append(value)
    }
    ///计算数组中所值的和并将结果返回
    func compute(strategy: Strategy) -> Int {
//        return self.numbers.reduce(0) { x,y in x + y }
        return strategy.execute(value: self.numbers)
    }
}

let sequence = Sequence([1,2,3,4])
sequence.addNumeber(value: 10)
sequence.addNumeber(value: 20)

let sum = sequence.compute(strategy: SumStrategy())
print("Sum: \(sum)")

let multiply = sequence.compute(strategy: MultiplyStrategy())
print("Multiply: \(multiply)")

///Sequence重定义了一个简单的算法,计算所有数值的和。
///如果想在给类添加一个算法,有两个方案可供选择。一个是修改Sequence类的代码,另一个方法是创建一个子类,让它覆盖现有算法,并有效地取代它。
///策略模式通过定义一个不同算法类都可以遵循的协议方式,实现了对开闭原则的支持。使用策略模式可以在不修改原有类的情况下,添加新的算法或者在运行时选择和切换算法。



