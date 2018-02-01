import Cocoa
/*:
> 使用观察者模式可以让一个独享在不对另一个对象产生依赖的情况下，注册并接受该对象发出的通知
 */
//实现观察者模式
protocol Observer: class {
    func notify(user: String, success: Bool)
}

protocol Subject {
    func addObservers(observers: [Observer])
    func removeObserver(oberver: Observer)
}

class SubjectBase: Subject {
    private var observers = [Observer]()
    private var collectionQueue = DispatchQueue(label: "colQ")
    
    func addObservers(observers: [Observer]) {
        collectionQueue.sync(flags: DispatchWorkItemFlags.barrier) {
            observers.forEach {
                self.observers.append($0)
            }
        }
    }
    
    func removeObserver(oberver: Observer) {
        collectionQueue.sync(flags: DispatchWorkItemFlags.barrier) {
            observers = observers.filter {_ in
                return true
            }
        }
    }
    
    func sendNotification(user: String, success: Bool) {
        collectionQueue.sync {
            observers.forEach {
                $0.notify(user: user, success: success)
            }
        }
    }
}

class ActivityLog: Observer {
    func logActivity(_ activitity: String) {
        print("Log: \(activitity)")
    }
    
    func notify(user: String, success: Bool) {
        print("Auth request for \(user). Success: \(success)")
    }
}

class FileCache: Observer {
    func loadFiles(user: String) {
        print("Load files for \(user)")
    }
    func notify(user: String, success: Bool) {
        if success {
            loadFiles(user: user)
        }
    }
}

class AttackMonitor: Observer {
    var monitorSuspiciousActivity: Bool = false {
        didSet {
            print("Monitoring for attack: \(monitorSuspiciousActivity)")
        }
    }
    func notify(user: String, success: Bool) {
        monitorSuspiciousActivity = !success
    }
}

class AuthenticationManager: SubjectBase {
    func authenticate(user: String, pass: String) -> Bool {
        var result = false
        if (user == "bob" && pass == "secret") {
            result = true
            print("User \(user) is authenticated")
            log.logActivity(user)
        }else {
            print("Failed authentication attempt")
            log.logActivity("Failed authentication : \(user)")
        }
        
        sendNotification(user: user, success: result)
        
        return result
    }
}


let log = ActivityLog()
let cache = FileCache()
let montitor = AttackMonitor()


let authM = AuthenticationManager()
authM.addObservers(observers: [log,cache,montitor])
authM.authenticate(user: "bob", pass: "secret")
print("--------")
authM.authenticate(user: "joe", pass: "shhh")


