import SwiftSocket

public class Publisher {
    let client: TCPClient
    
    public init(ip: String, port: Int32) {
        client = TCPClient(address: ip, port: port)
    }
    
    public func connect(ip: String, port: Int32, callback: @escaping (Result<Bool>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.client.connect(timeout: 10)
            
            callback(Result<Bool>.from(result: result))
        }
    }
    
    public func registerPublisher(name: String, callback: @escaping (Result<Bool>) -> Void) {
        let message = BaseMessage(message: CUPUSMessages.registerPublisher(name: name))
        
        do {
            let data = try message.json()
            
            send(data: data, callback: callback)
        } catch let error {
            callback(Result<Bool>.failure(error: error))
        }
    }
    
    public func publish(geometry: Geometry, properties: [Property], callback: @escaping (Result<Bool>) -> Void) {
        let message = BaseMessage(message: CUPUSMessages.publish(payload: Payload(geometry: geometry, properties: properties), unpublish: false))
        
        do {
            let data = try message.json()
            
            send(data: data, callback: callback)
        } catch let error {
            callback(Result<Bool>.failure(error: error))
        }
    }
    
    func send(data: Data, callback: @escaping (Result<Bool>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = self.client.send(data: data)
            
            callback(Result<Bool>.from(result: result))
        }
    }
}
