//: Playground - noun: a place where people can play

import Cocoa

///将一个值赋给变量时，Swift会自动使用原型模式。值类型是使用结构体定义，而且所有Swift内置类型的底层都是用结构图实现。

struct Appointment {
    var name: String
    var day: String
    var place: String
    
    func printDetails(label: String) {
        print(label,name,day,place)
    }
}

var beerMeeting = Appointment(name: "hu", day: "1", place: "Pl")

var workMetting = beerMeeting

workMetting.name = "Alice"
workMetting.day  = "2"
workMetting.place = "NewPl"

beerMeeting.printDetails(label: "beer")
workMetting.printDetails(label: "work")

/// 创建完类型对象之后，可以克隆任意多个同类对象，而且不会引起直接使用结构体模板创建对象所带来的内存开销的问题
