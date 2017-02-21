enum JSONError: Error {
    case stringConversationFailed
}

protocol JSON {
    func json() throws -> Data
    var jsonDictionary: [String: Any] { get }
}

extension JSON {
    func json() throws -> Data {
        return try JSONSerialization.data(withJSONObject: jsonDictionary)
    }
}

struct BaseMessage {
    let messageId: String
    let senderId: String
    let timestamp: Int64
        
    let message: CUPUSMessages
    
    init(senderId: String, message: CUPUSMessages) {
        self.messageId = UUID().uuidString
        self.senderId = senderId
        self.message = message
        
        self.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
    }
}

extension BaseMessage: JSON {
    var jsonDictionary: [String: Any] {
        var jsonDictionary = [
            "eid": senderId,
            "id": messageId,
            "type": message.identifier,
            "timestamp": timestamp as Any
        ]
        
        jsonDictionary["message"] = try? message.jsonString()
        
        return jsonDictionary
    }
}
