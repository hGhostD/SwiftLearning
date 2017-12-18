import Cocoa
/*:
 > 享元模式可以在多个调用组件之间共享数据
 
 享元模式不会修改外部数据，也不允许调用组件修改外部数据。这是享元模式非常重要的特征，允许对外部数据进行修改也是人们在实现享元模式时常犯的一个错误。
 */

class Owner: NSObject, NSCopying {
    var name: String
    var city: String
    
    init(name: String, city: String) {
        self.name = name
        self.city = city
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        print("Copy")
        return Owner(name: self.name, city: self.city)
    }
}

class FlyweightFactory {
    class  func createFlyweight() -> Flyweight {
        return Flyweight(owner: ownerSingleton)
    }
    
    private class var ownerSingleton: Owner {
        get {
            struct singleTonWrapper {
                static let singleon = Owner(name: "Anonymous", city: "Anywhere")
            }
            return singleTonWrapper.singleon
        }
    }
}

class Flyweight {
    private let extrinsicOwner: Owner
    
    private var intrinsicOwner: Owner?
    
    init(owner: Owner) {
        self.extrinsicOwner = owner
    }
    
    var name: String {
        get { return intrinsicOwner?.name ?? extrinsicOwner.name }
        set(value) {
            decoupleFromExtrinsic()
            intrinsicOwner?.city = value
        }
    }
    
    private func decoupleFromExtrinsic() {
        if (intrinsicOwner == nil) {
            intrinsicOwner = extrinsicOwner.copy(with: nil) as? Owner
        }
    }
}

let fac = FlyweightFactory.createFlyweight()
let ff = Flyweight(owner: Owner(name: "hu", city: "Shenyang"))
print(ff.name,fac.name)
