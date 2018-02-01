import Cocoa
/*:
 > 中介者模式通过引入中介者对象的方式简化了同类对象之间的通信。
 使用中介者模式后，对象无需与其他对象保持联系，只需中介者对象交互
*/

struct Position {
    var distanceFromRunway: Int
    var height: Int
}

class Airplane: Equatable {
    var name: String
    var currentPosition: Position
    private var otherPlanse: [Airplane]
    
    init(name: String, initialPos: Position) {
        self.name = name
        self.currentPosition = initialPos
        self.otherPlanse = [Airplane]()
    }
    
    func addPlanesInArea(planes: [Airplane]) {
        planes.forEach {
            otherPlanse.append($0)
        }
    }
    
    func otherPlaneDidLand(plane: Airplane) {
        if let index = otherPlanse.index(of: plane) {
            otherPlanse.remove(at: index)
        }
    }
    
    func otherPlaneDidChangePosition(plane: Airplane) -> Bool {
        return plane.currentPosition.distanceFromRunway == self.currentPosition.distanceFromRunway && abs(plane.currentPosition.height - self.currentPosition.height) < 1000
    }
    
    func changePosition(newPosition: Position) {
        self.currentPosition = newPosition
        otherPlanse.forEach {
            if $0.otherPlaneDidChangePosition(plane: self) {
                print("\(name): Too close! Abort!")
            }
        }
        print("\(name): Position changed")
    }
    
    func land() {
        self.currentPosition = Position(distanceFromRunway: 0, height: 0)
        otherPlanse.forEach {
            $0.otherPlaneDidLand(plane: self)
        }
        print("\(name): Landed")
    }
}

func == (lhs: Airplane, rhs: Airplane) -> Bool {
    return lhs.name == rhs.name
}

let british = Airplane(name: "HU", initialPos: Position(distanceFromRunway: 11, height: 21000))

let american = Airplane(name: "Ame", initialPos: Position(distanceFromRunway: 12, height: 22000))
british.addPlanesInArea(planes: [american])
american.addPlanesInArea(planes: [british])

british.changePosition(newPosition: Position(distanceFromRunway: 8, height: 1000))
british.changePosition(newPosition: Position(distanceFromRunway: 2, height: 5000))
british.changePosition(newPosition: Position(distanceFromRunway: 1, height: 1000))



british.land()
