import Cocoa
/*:
> 其实这个设计模式就是我们通常概念的 **面向对象** 编程。使用 **类** 或者 **结构体** 作为数据类型及其逻辑的规范。创建对象时使用 **模板**，并在初始化是完成数据赋值。赋值时，要么使用模板中的 **默认值**，要么使用类或者结构体的 **构造器** 提供数值。
 
*/
///模拟商品数据
var products = [("Ka","A boat for one person",25.0,10),
                ("Li","Protecctive and fashionable",48.95,14),
                ("So","FIAFA size and weight",19.5,32)]

/* 以下是错误的设计模式--- 由于对数据的过度依赖index 形成了高耦合 难以进行维护
    当从模拟商品数据删除某一项数据时 会造成程序的崩溃
 */
///计算商品税 20%
func calculateTax(produce:(String,String,Double,Int)) -> Double {
    return produce.2 * 0.2
}
///计算总价格
func calculateValue(dataArr:[(String,String,Double,Int)]) -> Double {
    return dataArr.reduce(0, {
        (total,product) -> Double in
        return total + (product.2 * Double(product.3))
    })
}
calculateTax(produce: products[0])
calculateValue(dataArr: products)

///所以面向对象编程思想能够更好的避免这个问题 将元组数据进行抽象 模块化 
struct productStr {
    let name: String
    let detail: String
    let price: Double
    let number: Int
}
let proStr = productStr(name: "KA", detail: "st", price: 10.2, number: 10)
/*:
 > 支持封装是使用 类 或者 结构体 作为数据对象模板最重要的优点。
 */
class productClass {
    open var name: String //open 最高的开放权限
    public var detail: String //publish公开的访问权限 internal 为默认权限
    fileprivate var price: Double //fileprivate 文件内访问权限
    private var number: Int //private 私有访问权限 
    // final 关键字可以用在 class，func 或者 var 前面进行修饰，表示不允许对该内容进行继承或者重写操作。
    init(name: String, detail: String, price: Double, number: Int) {
        self.name = name
        self.detail = detail
        self.price = price
        self.number = number
    }
    // 添加一个 计算属性，并实现计算库存总值的方法
    var stockValue: Double {
        get {
            return self.price * Double(self.number)
        }
    }
    // 演化 -->  可以通过重写 set get 方法来确保值有意义
    private var inValue = 0
    var outValue: Int {
        get {
            return inValue
        }
        set {
            inValue = max(0, newValue)
        }
    }
}
let proClass = productClass(name: "FA", detail: "fi", price: 20.2, number: 3)
proClass.outValue = 10
proClass.outValue
proClass.outValue = -10
proClass.outValue
