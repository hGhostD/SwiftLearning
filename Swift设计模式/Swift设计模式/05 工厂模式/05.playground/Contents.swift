//: Playground - noun: a place where people can play

import Cocoa

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
        return car?.name
    }
}