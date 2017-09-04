//: Playground - noun: a place where people can play

import Cocoa

struct Message {
    let from: String
    let to:   String
    let subject: String
}

class LocalTransmitter {
    func sendMessage(_ message: Message) {
        print("Message to \(message.to) sent locally")
    }
}

class RemoteTransmitter {
    func sendMessage(_ message: Message) {
        print("Message to \(message.to) sent remotely")
    }
}

let message = [Message(from: "bob", to: "joe", subject: "lunch"),Message(from: "joe", to: "alice", subject: "new"),Message(from: "pete", to: "all", subject: "Meeting")]

let localT = LocalTransmitter()
let remoteT = RemoteTransmitter()

message.forEach {
    localT.sendMessage($0)
}

