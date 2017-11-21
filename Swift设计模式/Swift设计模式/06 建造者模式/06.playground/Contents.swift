import Cocoa
/*:
 > 使用建造者模式可以将创建对象所需的逻辑和默认配置值放入一个建造者类中，这样调用组件只需了解少量配置数据即可创建对象，并且无需了解创建对象所需的默认数据值。
 
 使用建造者模式的第一步是定义建造者类,此类应包含创建Burger对象所需参数的默认值,并为调用组件改变这些默认配置提供相应的方式
 */
class Burger{
    let customerName: String
    let veggieProduct: Bool
    let patties: Int
    let pickles: Bool
    let mayo: Bool
    let ketchup: Bool
    let lettuce: Bool
    let cook: Cooked
    
    enum Cooked: String {
        case RARE = "Rare"
        case NORMAL = "Normal"
        case WELLDONE = "Well Done"
    }
    init(name: String, veggie: Bool, patties: Int, pickles: Bool, mayo: Bool, ketchup: Bool, lettuce: Bool, cook: Cooked) {
        self.customerName = name
        self.veggieProduct = veggie
        self.patties = patties
        self.pickles = pickles
        self.mayo = mayo
        self.ketchup = ketchup
        self.lettuce = lettuce
        self.cook = cook
    }
    func printDesciption() {
        print("Name \(customerName)\nVeggie \(veggieProduct)\nPatties \(patties)\nPickels \(pickles)\nMayo \(mayo)\nKetchup \(ketchup)\nLettuce \(lettuce)\nCook \(cook.rawValue)")
    }
}
class BurgerBuilder {
    private var veggie  = false
    private var pickles = true
    private var mayo    = true
    private var ketchup = true
    private var lettuce = true
    private var patties = 2
    private var cooked  = Burger.Cooked.NORMAL
    
    func setVeggie(_ choice: Bool) {self.veggie = choice}
    func setPickles(_ choice: Bool) {self.pickles = choice}
    func setMayo(_ choice: Bool) {self.mayo = choice}
    func setKetchup(_ choice: Bool) {self.ketchup = choice}
    func setLettuce(_ choice: Bool) {self.lettuce = choice}
    func addPatty(_ choice: Bool) {self.patties = choice ? 3 : 2}
    func setCooked(_ choice: Burger.Cooked) {self.cooked = choice}
    
    func buildObject(_ name: String) -> Burger {
        return Burger(name: name, veggie: veggie, patties: patties, pickles: pickles, mayo: mayo, ketchup: ketchup, lettuce: lettuce, cook: cooked)
    }
}

///使用建造者
var builder = BurgerBuilder()
//定义名字
let name = "hu"
//询问是否suca
builder.setVeggie(false)
//是否定制汉堡
builder.setMayo(false)
builder.setCooked(Burger.Cooked.WELLDONE)
//是否需要添加肉饼
builder.addPatty(false)

let oreder = builder.buildObject(name)

oreder.printDesciption()
///当有需求要改动 Burger类时 可以最小的影响项目 来实现功能 
