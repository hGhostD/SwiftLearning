import Cocoa
/*:
 >命令模式提供了一种封装方法调用的机制，基于这种机制我们可以实现延迟方法调用或替换调用该方法的组用。
 命令模式的核心是 命令对象。在其内部实现中，接受对象持有一个命令 接收者对象 的引用，并知道如何调用接收者的相关方法。接收者和调用指令是命令私有的，不应允许使用命令的调用组件去访问。命令对象唯一的可供公开访问的是execution 方法。当调用组件需要执行相关命令时，直接调用 execution 即可。
 实现命令模式的第一步就是定义一个为调用者提供execution方法的协议
*/
//需要添加并发保护
protocol Command {
    func execute()
}

class GenericCommon<T>: Command {
    private var receiver: T
    private var instructions: (T) -> Void
    
    func execute() {
        instructions(receiver)
    }
    
    
    init(receiver: T, instructions: @escaping (T) -> Void) {
        self.receiver = receiver
        self.instructions = instructions
    }
    
    class func createCommand(receiver: T, instructions: @escaping (T) -> Void) -> Command {
        return GenericCommon(receiver: receiver, instructions: instructions)
    }
}
class Calculator {
    private(set) var total = 0
    private var history = [Command]()
    //创建保护线程
    private var queue = DispatchQueue(label: "arrayQ")
    ///用变量来标识当前是否在执行命令，可放置引用锁死。GCD不支持递归锁。
    private var performingUndo = false
    
    private func addUndoCommand(method: @escaping (Calculator) -> (Int) -> Void,amout: Int) {
        if !performingUndo {
            queue.sync {
                self.history.append(GenericCommon<Calculator>.createCommand(receiver: self, instructions: {
                    method($0)(amout)
                }))
            }
        }
    }
    
    func undo() {
        queue.sync {
            if self.history.count > 0 {
                performingUndo = true
                history.removeLast().execute()
                performingUndo = false
            }
        }
    }
    
    func add(amout: Int) {
        addUndoCommand(method: Calculator.subtract, amout: amout)
        total += amout
    }
    
    func subtract(amout: Int) {
        addUndoCommand(method: Calculator.add, amout: amout)
        total -= amout
    }
    
    func multiply(amout: Int) {
        addUndoCommand(method: Calculator.divide, amout: amout)
        total = total * amout
    }
    
    func divide(amout: Int) {
        addUndoCommand(method: Calculator.subtract, amout: amout)
        total = total / amout
    }
}

let calc = Calculator()
calc.add(amout: 10)
calc.multiply(amout: 4)
calc.subtract(amout: 2)


print(calc.total)
//最后一步是在Calculator类中加入撤销功能
for _ in 0..<3 {
    calc.undo()
    print("Undo called Total: \(calc.total)")
}
