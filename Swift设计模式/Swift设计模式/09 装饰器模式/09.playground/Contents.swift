//: Playground - noun: a place where people can play

import Cocoa

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

let account = CustomerAccount(name: "hu")

account.addPurchase(purchase: Purchase(product: "Car", price: 10000.00))
account.addPurchase(purchase: Purchase(product: "Hourse", price: 233.12))

account.printAccount()