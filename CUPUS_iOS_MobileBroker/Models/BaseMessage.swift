struct BaseMessage {
    let messageId: String
    let senderId: String
    let timestamp: Int64
        
    let message: CUPUSMessages
    
    init(messageId: String, senderId: String, timestamp: Int64, message: CUPUSMessages) {
        self.messageId = messageId
        self.senderId = senderId
        self.timestamp = timestamp
        self.message = message
    }

    init(message: CUPUSMessages) {
        self.messageId = UUID().uuidString
        self.senderId = (UIDevice.current.identifierForVendor ?? UUID()).uuidString
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
        
        jsonDictionary["message"] = message.jsonDictionary
        
        return jsonDictionary
    }
}

//"eid":"d8527f2e-e443-4ea5-9d3d-e15a9ff0845b","id":"4d49fbd4fdd0af534ab4c4d63af8743","type":"NotifyMessage","message":{"payload":{"startTime":1490362793605,"geometry":{"coordinates":[45.815011,15.981919],"type":"Point"},"validity":-1,"properties":[{"value":"SensorReading","key":"Type"},{"value":1.0,"key":"ID"},{"value":20,"key":"co"}]},"unpublish":"False","type":"HashtablePublication"},"timestamp":1490362794561}
