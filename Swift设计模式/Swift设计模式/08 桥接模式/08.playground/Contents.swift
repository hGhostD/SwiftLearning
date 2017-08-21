//: Playground - noun: a place where people can play

import Cocoa

/*
 为了更高的解决层级爆炸的问题,分离应用的抽象部分与实现部分,使他们可以独立的变化
 */


protocol ClearMessageChannel {
    func send(message: String)
}

protocol SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String)
}
///创建一个桥接的类 类中属相 遵守不同的协议 并为属性创建 能够调用协议方法 的方法
class Communicator {
    private let clearChannel: ClearMessageChannel
    private let secureChannel: SecureMessageChannel
    
    init(clearChannel: ClearMessageChannel, secureChannel: SecureMessageChannel) {
        self.secureChannel = secureChannel
        self.clearChannel = clearChannel
    }
    
    func sendCleartextMessage(mesage: String) {
        self.clearChannel.send(message: mesage)
    }
    
    func sendSecureMessage(message: String) {
        self.secureChannel.sendEncryptedMessage(encryptedText: message)
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
        print("Secure",encryptedText)
    }
}
///通过桥连创建对象 并调用对象方法
var comms = Communicator(clearChannel: Landline(), secureChannel: SecureLandLine())

comms.sendCleartextMessage(mesage: "CLEAR")
comms.sendSecureMessage(message: "sercure")
