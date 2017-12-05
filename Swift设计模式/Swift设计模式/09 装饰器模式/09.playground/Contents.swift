import Cocoa
/*:
 >  此模式在处理无法修改的类时能发挥强大的功能。可以在不修改对象所属的类或对象的使用者情况下，修改单个对象的行为。
 
 假设现在我们想为顾客提供礼品服务，但是又不想修改定义的商品类和顾客类
 */
/// 定义一个购买商品的类 包含购买商品的名称和价格
class Purchase {
    private let product: String
    private let price: CGFloat

    init(product: String, price: CGFloat) {
        self.product = product
        self.price   = price
    }

    var description: String {
        return product
    }

    var totalPrice: CGFloat {
        return price
    }
}
//// 定义一个顾客的类 可以添加购买商品并付款
class CustomerAccount {
    let customerName: String
    var purchases = [Purchase]()

    init(name: String) {
        self.customerName = name
    }

    func addPurchase(purchase: Purchase){
        self.purchases.append(purchase)
    }

    func printAccount() {
        var total: CGFloat = 0
        purchases.forEach {
            total += $0.totalPrice
            print("Purcahse \($0.description), Price \(formatCurrencyString(number:$0.totalPrice))")
        }

        print("Total due: \(formatCurrencyString(number: total))")
    }

    func formatCurrencyString(number: CGFloat) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(for: number) ?? ""

    }
}

/// 定义一个礼品类
class PurchaseWithGiftWrap: Purchase {
    override var description: String { return "\(super.description) + gifwrap" }
    override var totalPrice: CGFloat { return super.totalPrice + 2 }
}

class PurchaseWithRibbon: Purchase {
    override var description: String { return "\(super.description) + ribbon" }
    override var totalPrice: CGFloat { return super.totalPrice + 1 }
}

class PurchaseWithDelivery: Purchase {
    override var description: String { return "\(super.description) + delivery" }
    override var totalPrice: CGFloat { return super.totalPrice + 5 }
}
/// 此时如果我们想给商品添加礼品 只能一个个的创建添加 不能自由组合

let account = CustomerAccount(name: "hu")

account.addPurchase(purchase: Purchase(product: "Car", price: 10000.00))
account.addPurchase(purchase: Purchase(product: "Hourse", price: 233.12))

account.printAccount()
