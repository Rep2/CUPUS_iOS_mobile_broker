public class Subscriber {
    
    let id: String
    
    let connectionDelegate: ConnectionDelegate
    let connection: Connection
    
    public init(host: String = "127.0.0.1", port: Int = 10000) throws {
        self.id = UUID().uuidString
        
        connectionDelegate = ConnectionDelegate()
        connection = try Connection.connect(host: host, port: port, delegate: connectionDelegate)
    }
    
    public func registerSubscriber(callback: @escaping () -> Void) throws {
        let message = BaseMessage(senderId: id, message: CUPUSMessages.registerSubscriber(name: "CUPUS iOS app", ip: "192.168.1.14", port: 0, senderId: id))
        
        try connectionDelegate.write(data: message.json(), callback: callback)
    }
    
    public func subscribe(callback: @escaping () -> Void) throws {
        let message = BaseMessage(senderId: id, message: .subscribe(features: [Feature(property: PredicateMap(predicates: [Predicate()]))]))
        
        try connectionDelegate.write(data: message.json(), callback: callback)
    }
    
}
