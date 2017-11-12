import Cocoa
/*:
 > 对象池模式是单例模式的一种变体，它可以为组件提供多个完全相同的对象，而非单个对象。对象池模式一般来管理一组可重用的对象，
 
 此模式解决的问题：需要限制某个类型对象的数量，但允许多个个对象的存在。例如图书管理系统，需要管理某本书，但是又是多本存在。
 
 常见情况:UITableviewCell 的重用
 */
class Book {
    let author: String
    let title: String
    let stockNumber: Int
    var reader: String?
    var checkoutCount = 0
    
    init(author: String, title: String, stock: Int) {
        self.author = author
        self.title = title
        self.stockNumber = stock
    }
}
///实现对象池模式
///定义Pool类
class Pool<T> {
    private var data = [T]()
    private let arrayQ = DispatchQueue(label: "arrayQ")
    ///创建GCD信号源
    private let semaphore: DispatchSemaphore
    
    init(items:[T]) {
        // 为了给 data 申请合适的内存空间 需要调用这个方法
        data.reserveCapacity(data.count)
        semaphore = DispatchSemaphore(value: items.count)

        items.forEach{
            data.append($0)
        }
    }
    
    func getFromPool() -> T? {
        var result: T?
        if semaphore.wait(timeout: .distantFuture) == .success {
            arrayQ.sync {
                result = self.data.remove(at: 0)
            }
        }
        return result
    }
    
    func returnToPool(item: T) {
        arrayQ.sync {
            self.data.append(item)
            semaphore.signal()
            DispatchWorkItem(qos: .default, flags: .barrier, block: {
                
            })
        }
    }
}

final class Library {
    private var books: [Book]
    private let pool: Pool<Book>
    
    init(stockLevel: Int) {
        books = [Book]()

        for i in 1...stockLevel {
             books.append(Book(author: "hu", title: "Time", stock: i))
        }
        
        pool = Pool<Book>(items: books)
    }
    
    private class var Singleton: Library {
        struct SingletonWrapper {
            static let singleton = Library(stockLevel: 2)
        }
        return SingletonWrapper.singleton
    }
    
    class func checkoutBook(reader: String) -> Book? {
        let book = Singleton.pool.getFromPool()
        book?.reader = reader
        book?.checkoutCount += 1
        return book
    }
    
    class func returnBook(book: Book) {
        book.reader = nil
        Singleton.pool.returnToPool(item: book)
    }
    
    class func printReport() {
        Singleton.books.map {
            print("===Book: \($0.stockNumber)")
            print("Checked out \($0.checkoutCount) tiems")
            if $0.reader != nil {
                print("Checked out to \($0.reader!)")
            }else {
                print("In stock")
            }
        }
    }
}

var queue = DispatchQueue(label: "workQ", attributes: .concurrent)
var group = DispatchGroup()

print("开始...")
for i in 1...30 {
    queue.async(group: group) {
        let book = Library.checkoutBook(reader: "reader#\(i)")
        if book != nil {
            
            sleep(arc4random() % 1)
            
            Library.returnBook(book: book!)
        }
    }
}

group.wait(wallTimeout: .distantFuture)
print("全部完成")

Library.printReport()

