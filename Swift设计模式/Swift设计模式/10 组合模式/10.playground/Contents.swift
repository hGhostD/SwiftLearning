import Cocoa
/*:
 > 组合模式能够将对象以树形结构组织起来，使得外界对单个对象和组合对象的使用具有一致性。
 */

protocol CarPart {
    var name: String { get }
    var price: Float { get }
}

class Part: CarPart {
    let name: String
    let price: Float

    init(name: String, price: Float) {
        self.name = name
        self.price = price
    }
}

class CompositePart: CarPart {
    let name: String
    let parts: [CarPart]

    init(name: String, parts: CarPart...) {
        self.name = name
        self.parts = parts
    }
    
    var price: Float {
        return parts.reduce(0) { subtotal, part in
            return subtotal + part.price
        }
    }
}

class CustomerOrder {
    let customer: String
    let parts: [CarPart]
    let compositeParts: [CompositePart]

    init(customer: String, part: [Part], composites: [CompositePart]) {
        self.customer = customer
        self.parts = part
        self.compositeParts = composites
    }

    var totalPrice: Float {
        let partReducer = { (subtotal: Float, part: CarPart) -> Float in
            return subtotal + part.price
        }

        let total = parts.reduce(0, partReducer)

        return compositeParts.reduce(total) { (subtotal, cpart) -> Float in
            return cpart.parts.reduce(subtotal, partReducer)
        }
    }

    func printDeails() {
        print("Order for\(customer): Cost: \(formatCurrencyString(totalPrice))")
    }

    func formatCurrencyString(_ number: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(for: number) ?? ""
    }
}

let doorWindow = CompositePart(name: "window", parts:
                            Part(name: "wp1", price: 100.50),
                            Part(name: "wp2", price: 12))
let door = CompositePart(name: "Door", parts: doorWindow, Part(name: "Door Loom", price: 80))

let hood = Part(name: "Hood", price: 320)
let order = CustomerOrder(customer: "Bob", part: [], composites: [door])
order.printDeails()
