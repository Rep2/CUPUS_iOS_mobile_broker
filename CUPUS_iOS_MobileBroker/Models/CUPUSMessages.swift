enum CUPUSMessages: JSON {
    case registerPublisher(name: String, senderId: String)
    case registerSubscriber(name: String, ip: String, port: Int, senderId: String)
    case publish(features: [Feature], startTime: Int64)
    case subscribe(features: [Feature])
    
    var identifier: String {
        switch self {
        case .registerPublisher:
            return "PublisherRegisterMessage"
        case .registerSubscriber:
            return "SubscriberTcpRegisterMessage"
        case .publish:
            return "PublishMessage"
        case .subscribe:
            return "SubscribeMessage"
        }
    }
    
    var jsonDictionary: [String: Any] {
        switch self {
        case .registerPublisher(let name, let senderId):
            return [
                "en": name,
                "id": senderId
            ]
        case .registerSubscriber(let name, let ip, let port, let senderId):
            return [
                "port": String(port),
                "ip": ip,
                "en": name,
                "id": senderId
            ]
        case .publish(let features, let startTime):
            return [
                "unpublish": "False",
                "publicationType": "HashtablePublication",
                "publicationJSON": Publication(features: features, startTime: startTime).jsonDictionary
            ]
        case .subscribe(let features):
            let startTime = Int64(Date().timeIntervalSince1970 * 1000)
            
            return [
                "unsubscribe": "False",
                "subscriptionType": "TripletSubscription",
                "subscriptionJSON": Publication(features: features, startTime: startTime).jsonDictionary
            ]
        }
    }
    
    func jsonString() throws -> String {
        if let jsonString = try String(data: json(), encoding: .ascii) {
            return jsonString
        } else {
            throw JSONError.stringConversationFailed
        }
    }
}
