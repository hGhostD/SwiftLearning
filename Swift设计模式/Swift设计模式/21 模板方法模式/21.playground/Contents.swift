//: # 21 模板方法模式

//: > 模板方法可以允许第三方开发者,以创建子类或者定义闭包的方式,替换一个算法的某些步骤的具体实现
import Cocoa

struct Donor {
    let title: String
    let firstName: String
    let familyName: String
    let lastDonation: Float
    
    init(_ title: String, _ first: String, _ family: String, _ last: Float) {
        self.title = title
        self.firstName = first
        self.familyName = family
        self.lastDonation = last
    }
}

class DonorDatabase {
    private var donors: [Donor]
    
    init() {
        donors = [Donor("Ms","Anne","Jones",0),
                  Donor("Mr","Bob","Smith",100),
                  Donor("Dr","Alice","Doe",200),
                  Donor("Prof","Joe","Davis",320)]
    }
    
    func generateGalaInvitations(_ maxNumber: Int) -> [String] {
        var targetDonors: [Donor] = donors.filter { $0.lastDonation > 0 }
        
        targetDonors.sort { (first, second) -> Bool in
            first.lastDonation > second.lastDonation
        }
        
        if (targetDonors.count > maxNumber) {
            targetDonors = Array(targetDonors[0..<maxNumber])
        }
        
        return targetDonors.map {
            return "Dear \($0.title). \($0.familyName)"
        }
    }
}

let donorDb = DonorDatabase()

let galaInvitations = donorDb.generateGalaInvitations(2)
galaInvitations.forEach { print($0)}
