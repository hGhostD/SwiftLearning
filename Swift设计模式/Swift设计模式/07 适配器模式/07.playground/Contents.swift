//: Playground - noun: a place where people can play

import Cocoa

struct Employee {
    var name: String
    var title: String
}

protocol EmpployeeDataSource {
    var employees: [Employee] { get }
    func searchByName(name: String) -> [Employee]
    func searchByTitle(title: String) -> [Employee]
}

class DataSourceBase: EmpployeeDataSource {
    var employees: [Employee]
    
    func searchByName(name: String) -> [Employee] {
        return search {
            return $0.name.contains(name)
        }
    }
    
    func searchByTitle(title: String) -> [Employee] {
        return search {
            return $0.title.contains(title)
        }
    }
    
    func search(_ selector: ((Employee) -> Bool)) -> [Employee] {
        
        let results = employees.filter {
            selector($0)
        }
        return results
    }
    
    init() {
        employees = [Employee]()
    }
}

class SalesDataSource: DataSourceBase {
    override init() {
        super.init()
        employees.append(Employee(name: "hu", title: "title"))
    }
}
class DevelopmentDataSource: DataSourceBase {
    override init() {
        super.init()
        employees.append(Employee(name: "Joe", title: "Development"))
    }
}
//实现用例 创建一个搜索类
class SearchTool {
    enum SearchType {
        case Name,Title
    }
    
    private let source: [EmpployeeDataSource]
    
    init(dataSource: [EmpployeeDataSource]) {
        self.source = dataSource
    }
    
    var employees: [Employee] {
        var results = [Employee]()
        source.forEach {
            results += $0.employees
        }
        return results
    }
    
    func search(text: String, type: SearchType) -> [Employee] {
        var results = [Employee]()
        
        source.forEach {
            results += type == SearchType.Name ? $0.searchByName(name: text) : $0.searchByTitle(title: text)
        }
        return results
    }
}

let search = SearchTool(dataSource: [SalesDataSource(),DevelopmentDataSource()])

print("--List--")
search.employees.forEach {
    print("Name: \($0.name)")
}
print("--Search--")
search.search(text: "title", type: SearchTool.SearchType.Title).forEach {
    print("Name:\($0.name) Title:\($0.title)")
}
