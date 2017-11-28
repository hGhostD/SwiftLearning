import Cocoa

/*:
 > 桥接模式通过分离应用的抽象部分与实现部分，使得他们可以独立的变化。为了更高的解决层级爆炸的问题,分离应用的抽象部分与实现部分,使他们可以独立的变化
 
从表面上看,桥接模式与适配器模式甚是相似。毕竟桥接模式的功能就是充当依赖某个协议的类与另外协议之间的适配器。虽然桥接模式和适配器模式相似，但是它们 的应用场景并不相同。当需要集成无法修改源码的组件时(比如第三方组件),可以使用适配器模式。当你能够修改组件源代码及其运行方式时，便可使用桥接模式。使用桥接模式不只是创建一个桥接类这么简单，还需要最组件代码进行重构，以分离通用的代码和平台相关代码。
 */
protocol ClearMessageChannel {
    func send(message: String)
}

protocol SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String)
}

protocol PriorityMessageChannel {
    func sendPriority(message: String)
}
///创建一个桥接的类 类中属相 遵守不同的协议 并为属性创建 能够调用协议方法 的方法
class Communicator {
    private let clearChannel: ClearMessageChannel
    private let secureChannel: SecureMessageChannel
    private let priorityChannel: PriorityMessageChannel
    
    init(clearChannel: ClearMessageChannel, secureChannel: SecureMessageChannel, priorityChannel: PriorityMessageChannel) {
        self.secureChannel = secureChannel
        self.clearChannel = clearChannel
        self.priorityChannel = priorityChannel
    }
    
    func sendCleartextMessage(mesage: String) {
        self.clearChannel.send(message: mesage)
    }
    
    func sendSecureMessage(message: String) {
        self.secureChannel.sendEncryptedMessage(encryptedText: message)
    }
    
    func sendPriority(message: String) {
        self.priorityChannel.sendPriority(message: message)
    }
}
///创建不同的类 各自遵循各自的协议
class Landline: ClearMessageChannel {
    func send(message: String) {
        print("Landline",message)
    }
}

class SecureLandLine: SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String) {
        print("Secure", encryptedText)
    }
}

class PriorityMessage: PriorityMessageChannel {
    func sendPriority(message: String) {
        print("Priority", message)
    }
}
///通过桥连创建对象 并调用对象方法
var comms = Communicator(clearChannel: Landline(), secureChannel: SecureLandLine(), priorityChannel: PriorityMessage())

comms.sendCleartextMessage(mesage: "CLEAR")
comms.sendSecureMessage(message: "Sercure")
comms.sendPriority(message: "Flash")
