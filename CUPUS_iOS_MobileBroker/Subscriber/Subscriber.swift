import SwiftSocket

public class Subscriber {
    
    let client: TCPClient
    
    public init(ip: String, port: Int32) {
        client = TCPClient(address: ip, port: port)
    }

    public func connect(callback: @escaping (Result<Bool>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.client.connect(timeout: 10)
            
            callback(Result<Bool>.from(result: result))
        }
    }
    
    public func registerSubscriber(name: String, callback: @escaping (Result<Bool>) -> Void) {
        let message = BaseMessage(message: CUPUSMessages.registerSubscriber(name: name))
        
        do {
            let data = try message.json()
            
            send(data: data, callback: callback)
        } catch let error {
            callback(Result.failure(error: error))
        }
    }
    
    public func subscribe(geometry: Geometry?, predicates: [Predicate], callback: @escaping (Result<Bool>) -> Void, newPublicationCallback: @escaping ([Byte]?) -> Void) {
        let message = BaseMessage(message: CUPUSMessages.subscribe(payload: Payload(geometry: geometry, properties: predicates), unsubscribe: false))
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try message.json()
                
                let result = self.client.send(data: data)
                
                callback(Result<Bool>.from(result: result))
                
                repeat {
                    let publication = self.client.read(1000)
                    
                    newPublicationCallback(publication)
                } while true
            } catch let error {
                callback(Result.failure(error: error))
            }
        }
    }
    
    func send(data: Data, callback: @escaping (Result<Bool>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.client.send(data: data)
            
            callback(Result<Bool>.from(result: result))
        }
    }
}
