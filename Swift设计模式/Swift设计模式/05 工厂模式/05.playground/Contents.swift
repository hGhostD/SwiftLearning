import Cocoa
/*:
 > 工厂方法模式通过选取相关的实现类来满足调用组件的请求，调用组件无需了解这些实现类的细节以及它们之间的关系。当存在多个类共同实现一个协议或者共同继承一个基类时，就可以使用工厂方法模式。
 
 实现工厂方法模式最简单的方式是定义一个全局函数。由于全局函数可以在整个应用内调用，因此调用组件可以方便地定位和调用全局函数。
 */
func createRentalCar(passengers: Int) -> RentalCar? {
    var car: RentalCar?
    switch passengers {
    case 0...1:
        car = Sports()
    case 2...3:
        car = Compact()
    case 4...8:
        car = SUV()
    default:
        car = nil
    }
    return car
}
protocol RentalCar {
    var name: String { get }
    var passengers: Int { get }
    var pricePerDay: Float { get }
}

class Compact: RentalCar {
    var name = "Golf"
    var passengers = 3
    var pricePerDay: Float = 20
}

class Sports: RentalCar {
    var name = "Sport"
    var passengers = 1
    var pricePerDay: Float = 100
}

class SUV: RentalCar {
    var name = "SUV"
    var passengers = 8
    var pricePerDay: Float = 75
}

class CarSelector {
    class func selectCar(passengers: Int) -> String? {
        return createRentalCar(passengers: passengers)?.name
   }
}

let array = [1,3,5,9]
array.forEach {
    print(CarSelector.selectCar(passengers: $0) ?? "没有符合要求的车辆")
}

/*: 抽象工厂模式
    1. 创建抽象工厂类，它是抽象工厂模式的核心，因为它将被用作具体工厂类的基类。
    2. 创建具体的工厂类，它的职责是创建一组可以同时使用的产品对象。
 */
protocol Floorpan {
    var seats: Int { get }
    var enginePosition: EngineOption { get }
}
enum  EngineOption: String {
    case FRONT = "Front"; case MID = "Mid"
}
protocol Suspension {
    var suspensionType: SuspensionOption { get }
}
enum SuspensionOption: String {
    case STANDARD = "Standard"; case SPORTS = "Firm"; case SOFT = "Soft"
}
protocol Drivetrain {
    var driveType: DriveOption { get }
}
enum DriveOption: String {
    case FRONT = "Front"; case REAR = "Rear"; case ALL = "4WD"
}
class CarFactory {
    func createFloorplan() -> Floorpan{
        fatalError("Not implemented")
    }

    func createSuspension() -> Suspension {
        fatalError("Not implemented")
    }
    
    func createDrivetrain() -> Drivetrain {
        fatalError("Not implemented")
    }
}

