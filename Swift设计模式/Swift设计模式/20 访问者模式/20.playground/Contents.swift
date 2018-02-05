import Cocoa
/*:
 > 使用访问者模式,可以在不修改类的源代码和不创建新的子类的情况下拓展类的行为
*/

class Circle {
    let radius: Float
    
    init(radius: Float) {
        self.radius = radius    
    }
}

class Square {
    let length: Float
    
    init(length: Float) {
        self.length = length
    }
}

class Rectangle {
    let xLen: Float
    let yLen: Float
    
    init(x: Float, y: Float) {
        self.xLen = x
        self.yLen = y
    }
}
        
class ShapeCollection {
    let shapes:[Any]
    
    init() {
        shapes = [Circle(radius: 2.5), Square(length: 4), Rectangle(x:10, y :2)]
    }
    
    func calculateAreas() -> Float {
        return shapes.reduce(0, { (total,shape) in
            if let circle = shape as? Circle {
                print("Found Circle")
                return total + (3.14 * powf(circle.radius, 2))
            }else if let square = shape as? Square {
                print("Found Square")
                return total + powf(square.length, 2)
            }else if let rect = shape as? Rectangle {
                print("Found Rectangle")
                return total + (rect.xLen * rect.yLen) 
            }else {
                return total
            }
        })
    }
}

let shapes = ShapeCollection()
let area = shapes.calculateAreas()
print(area)
