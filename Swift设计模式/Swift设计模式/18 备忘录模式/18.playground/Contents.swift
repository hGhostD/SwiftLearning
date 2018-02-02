import Cocoa
/*:
 > 备忘录模式可以捕获一个对象的完整状态，并将其保存到一个备忘录对象中，以后可以根据备忘录重置对象的状态
 
 备忘录模式中有两个参与者，即原发器和管理者。原发器为需要回退状态的对象，管理者则告诉原发器将状态会退到哪一刻的状态。                 
*/
class LedgerEntry {
    let id: Int
    let counterParty: String
    let amount: Float
    
    init(id:Int, counterParty: String, amount: Float) {
        self.id = id
        self.counterParty = counterParty
        self.amount = amount
    }
}

class Ledger {
    private var entries = [Int: LedgerEntry]()
    private var nextId = 1
    var total: Float = 0
    
    func addEntry(counterParty: String, amount: Float) -> LedgerCommand {
        nextId += 1
        let entry = LedgerEntry(id: nextId, counterParty: counterParty, amount: amount)
        entries[entry.id] = entry
        total += amount
        return createUndoCommand(entry: entry)
    }
    
    private func createUndoCommand(entry: LedgerEntry) -> LedgerCommand {
        return LedgerCommand(instruction: { (targer) in
            let removed = targer.entries.removeValue(forKey: entry.id)
            if removed != nil {
                targer.total -= removed!.amount
            }
        }, receiver: self)
    }
    
    func printEntries() {
        for id in entries.keys.sorted() {
            if let entry = entries[id] {
                print("#\(id): \(entry.counterParty) \(entry.amount)")
            }
        }
        
        print("Total:\(total)")
        print("--------")
        
    }
}

class LedgerCommand {
    private let instructons: (Ledger) -> Void
    private let receiver: Ledger
    
    init(instruction: @escaping (Ledger) -> Void, receiver: Ledger) {
        self.instructons = instruction
        self.receiver = receiver
    }
    
    func execute() {
        self.instructons(self.receiver)
    }
}

let ledger = Ledger()
ledger.addEntry(counterParty: "Bob", amount: 100.43)
ledger.addEntry(counterParty: "Joe", amount: 200.20)
let undoCommand = ledger.addEntry(counterParty: "Alice", amount: 500)
ledger.addEntry(counterParty: "Tony", amount: 20)

ledger.printEntries()
undoCommand.execute()
ledger.printEntries()
