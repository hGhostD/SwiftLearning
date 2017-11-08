import Cocoa
/*:
 > 原型模式通过克隆已有的对象来创建新的对象，已有的对象即为原型
 
 组件若想通过模板创建新的对象，必须掌握以下三个信息。
 - 与所需创建的对象相关的模板
 - 必须调用的初始化器
 - 初始化器的参数名称和类型
 
 将一个值赋给变量时，Swift会自动使用原型模式。值类型是使用结构体定义，而且所有Swift内置类型的底层都是用结构图实现。
 
 换句话说: Swift 只会为 **值类型(结构体)** 创建默认的**初始化器**。而**不会**为 **引用类型(类)** 创建**初始化器**。这就会导致创建完原型对象后，之后再创建任意多个同类对象，使用 **结构体** 模板创建的对象不会带来内存开销问题，而使用 **类** 模板创建的对象会有内存指向的问题。(2个变量会指向同一个对象。)
 为了解决这个问题可以实现 NSCopying 协议，来支持克隆对象，实现深复制。
 */
struct Appointment {
    var name: String
    var day: String
    var place: String
    
    func printDetails(label: String) {
        print(label,name,day,place)
    }
}
/// 创建完类型对象之后，可以克隆任意多个同类对象，而且不会引起直接使用结构体模板创建对象所带来的内存开销的问题
var beerMeeting = Appointment(name: "hu", day: "1", place: "Pl")
var workMetting = beerMeeting

workMetting.name = "Alice"
workMetting.day  = "2"
workMetting.place = "NewPl"

beerMeeting.printDetails(label: "beer")
workMetting.printDetails(label: "work")

class AppointmentClass: NSCopying {
    var name: String
    var day: String
    var place: String
    
    init(name: String, day: String, place: String) {
        self.name = name; self.day = day; self.place = place
    }
    
    func printDetails(label: String) {
        print(label,name,day,place)
    }
    // 在实现 copyWithZone 方法时，可以忽略 NSZone 这个参数
    func copy(with zone: NSZone? = nil) -> Any {
        return AppointmentClass(name: self.name, day: self.day, place: self.place)
    }
}

var b1 = AppointmentClass(name: "bob", day: "1", place: "Bar")
var w1 = b1.copy() as! AppointmentClass
w1.name = "Ali"
w1.day  = "2"
w1.place = "Home"
b1.printDetails(label: "b1")
w1.printDetails(label: "w1")
