import Cocoa
/*:
 > 责任链模式负责组织管理一序列能够对调用组件的请求做出响应的对象。这里所说的对象序列被称为责任链，责任链中的每个对象都可能被用于处理某个请求。请求在这个链上传递，知道链上的某一个对象处理此请求，或者到达链的尾部。
 当多个对象可以响应一个请求，而又不想将这些对象的细节暴露给调用组件时，便可以使用责任链模式。
 */
/// 实现责任链模式
class Transmitter {
    var nextLinke: Transmitter?
    
    required init() { }
    
    func sendMessage(_ message: Message) {
        if (nextLinke != nil) {
            nextLinke?.sendMessage(message)
        } else {
            print("责任链到达底端，消息不再发送。")
        }
    }
    
    class func matchEmailSuffix(message: Message) -> Bool {
        // 判断收和发的邮箱是否是同一个
        if let index = message.from.index(of: "@"){
            let sub = String(message.from[index...])
            return message.to.hasSuffix(sub)
        }
        return false
    }
    // 创建一条责任链
    class func createChain() -> Transmitter? {
        let transmitterClasses: [Transmitter.Type] = [
            PriorityTransmitter.self,
            LocalTransmitter.self,
            RemoteTransmitter.self]
        
        var link: Transmitter?
        
        transmitterClasses.reversed().forEach {
            let existingLink = link
            link = $0.init()
            link?.nextLinke =  existingLink
        }
        return link
    }
}
struct Message {
    let from: String
    let to:   String
    let subject: String
}

class LocalTransmitter: Transmitter {
    override func sendMessage(_ message: Message)  {
        if (Transmitter.matchEmailSuffix(message: message)) {
            print("\(message.from) 发送的内部消息")
        } else {
            super.sendMessage(message)
        }
    }
}

class RemoteTransmitter: Transmitter {
    override func sendMessage(_ message: Message) {
        if (!Transmitter.matchEmailSuffix(message: message)) {
            print("\(message.from) 发送外部消息")
        } else {
            super.sendMessage(message)
        }
    }
}

class PriorityTransmitter: Transmitter {
    override func sendMessage(_ message: Message) {
        if (message.subject.hasPrefix("Priority")) {
            print("\(message.from) 发送 私人消息")
        } else {
            super.sendMessage(message)
        }
    }
}

let message = [Message(from: "bob@163.com", to: "joe@qq.com", subject: "午饭吃啥？"),
               Message(from: "joe@qq.com", to: "ali@qq.com", subject: "你吃啥？"),
               Message(from: "pet@2", to: "all@2", subject: "Priority: 这是私密消息！")]

if let chain = Transmitter.createChain()  {
    message.forEach {
        chain.sendMessage($0)
    }
}
