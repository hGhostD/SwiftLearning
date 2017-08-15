//: Playground - noun: a place where people can play

import Cocoa


///简单单例模式 可以直接通过 let logger = Logger() 创建一个全局常量,是惰性初始化,能够保证线程安全
final class Logger {
    private var data = [String]()
    
    func log(_ msg: String) {
        data.append(msg)
    }
    
    func pringLog() {
        data.forEach{
            print("Log: \($0)")
        }
    }
}

let logger = Logger()

logger.log("back 1")
logger.log("back 2")
logger.pringLog()

///处理并发
///串行访问

class DataItem {
    enum ItemType: String {
        case Email = "Email Address";
        case Photo = "Telephone Number"
        case Card  = "Credit Card Number"
    }
    
    var type: ItemType
    var data: String
    
    init(type: ItemType, data: String) {
        self.type = type
        self.data = data
    }
}

final class BackupServer {
    let name: String
    private var data = [DataItem]()
    private let arrayQ = DispatchQueue(label: "arrayQ")
    fileprivate init(name: String) {
        self.name = name
        logger.log("创建新对象\(name)")
    }
    
    func backup(item: DataItem) {
        arrayQ.sync {
            self.data.append(item)
            logger.log("\(self.name)支持的类型:\(item.type.rawValue)")
        }
    }
    
    func getData() -> [DataItem] {
        return data
    }
    
    class var server: BackupServer {
        struct SingletonWrapper {
            static let singleton = BackupServer(name: "Main")
        }
        return SingletonWrapper.singleton
    }
}

let hu = BackupServer(name: "hu")
let item = DataItem(type: .Email, data: "email")
let item2 = DataItem(type: .Photo, data: "photo")
let hu2 = BackupServer(name: "hu2")

hu.backup(item: item)
hu.backup(item: item2)

logger.pringLog()