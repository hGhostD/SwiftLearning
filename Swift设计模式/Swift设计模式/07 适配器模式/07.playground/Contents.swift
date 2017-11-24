import Cocoa
/*:
 > 适配器模式通过引入适配器对两个组件进行适配的方式，可以让两个 API 不兼容的组件写作。
 
 适配器模式通过对不同类的 API 进行适配，将应用使用的 API 映射到组件提供的 API 方式，使得两个不兼容的类可以相互协作。
 
 实现适配器模式最优雅的方式是使用 Swift extension。使用 extension 可以为无法修改源码的类增加功能。
 */
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

class NewCoStaffMember {
    private var name: String
    private var role: String
    
    init(name: String, role: String) {
        self.name = name
        self.role = role
    }
    
    func getName() -> String {
        return name
    }
    
    func getJob() -> String {
        return role
    }
}

class NewCoDirectory {
    private var staff: [String: NewCoStaffMember]
    
    init() {
        staff = ["Hans": NewCoStaffMember(name: "Hans", role: "role"),"Greta": NewCoStaffMember(name: "Greata", role: "VP,Legal")]
    }
    
    func getStaff() -> [String: NewCoStaffMember] {
        return staff
    }
}

extension NewCoDirectory: EmpployeeDataSource {
    var employees: [Employee] {
        return getStaff().values.map {
            return Employee(name: $0.getName(), title: $0.getJob())
        }
    }
    
    func searchByTitle(title: String) -> [Employee] {
        return createEmployees {
            return $0.getJob().contains(find: title)
        }
    }
    
    func searchByName(name: String) -> [Employee] {
        return createEmployees {
            return $0.getName().contains(find: name)
        }
    }
    
    private func createEmployees(filter filterClosure: ((NewCoStaffMember) -> Bool)) -> [Employee] {
        return getStaff().values.filter(filterClosure)
            .map{
                return Employee(name: $0.getName(), title: $0.getJob())
        }
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

let search = SearchTool(dataSource: [SalesDataSource(), DevelopmentDataSource(), NewCoDirectory()])

print("--List--")
search.employees.forEach {
    print("Name: \($0.name)")
}
print("--Search--")
search.search(text: "title", type: SearchTool.SearchType.Title).forEach {
    print("Name:\($0.name) Title:\($0.title)")
}
