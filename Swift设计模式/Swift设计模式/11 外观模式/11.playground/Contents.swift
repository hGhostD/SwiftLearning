//: Playground - noun: a place where people can play

import Cocoa

//外观模式可以简化复杂的常见任务 API的使用
//使用此模式后，调用组件的执行常见任务时对底层对象的祥光数据类型不存在依赖

class TreasureMap {
    enum Treasures {
        case GALLEON
        case BURIED
        case SUNKEN
    }
    
    struct MapLocation {
        let gridLetter: Character
        let grinNumber: uint
    }
    
    func findTreasure(type: Treasures) -> MapLocation {
        switch type {
        case .BURIED:
            return MapLocation(gridLetter: "D", grinNumber: 6)
        case .GALLEON:
            return MapLocation(gridLetter: "C", grinNumber: 2)
        default:
            return MapLocation(gridLetter: "F", grinNumber: 12)
        }
    }
}

class PirateShip {
    struct ShipLocation {
        let NorthSouth: Int
        let EastWest: Int
    }
    
    var currentPosition: ShipLocation
    let queue = DispatchQueue(label: "com")
    init() {
        currentPosition = ShipLocation(NorthSouth: 5, EastWest: 5)
    }
    
    func moveToLocation(location: ShipLocation, callBack:@escaping (ShipLocation) -> Void) {

        queue.async {
            self.currentPosition = location
            callBack(self.currentPosition)
        }
    }
}

class PirateCrew {
    let queue = DispatchQueue(label: "work")
    
    enum Actions {
        case ATTACK,DIG,DIVE
    }
    
    func performAction(action: Actions,callback:@escaping (Int) -> Void) {
        queue.async {
            var prizeValue = 0
            switch action {
            case .ATTACK:
                prizeValue = 10000
            case .DIG:
                prizeValue = 5000
            case .DIVE:
                prizeValue = 100
            }
            callback(prizeValue)
        }
    }
}
