import Cocoa

class Part {
    let name: String
    let price: Float

    init(name: String, price: Float) {
        self.name = name
        self.price = price
    }
}


class CompositePart {
    let name: String
    let parts: [Part]

    init(name: String, parts: Part...) {
        self.name = name
        self.parts = parts
    }
}

class CustomerOrder {
    let customer: String
    let parts: [Part]
    let compositeParts: [CompositePart]

    init(customer: String, part: [Part], composites: [CompositePart]) {
        self.customer = customer
        self.parts = part
        self.compositeParts = composites
    }

    var totalPrice: Float {
        let partReducer = { (subtotal: Float, part: Part) -> Float in
            return subtotal + part.price
        }

        let total = parts.reduce(0, partReducer)

        return compositeParts.reduce(total, { (subtotal, cpart) -> Float in
            return cpart.parts.reduce(subtotal, partReducer)
        })
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

let hood = Part(name: "Hood", price: 320)
let order = CustomerOrder(customer: "Bob", part: [hood], composites: [doorWindow])
order.printDeails()
