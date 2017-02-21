struct Predicate: JSON {
    let value: String
    let key: String
    let operatorIdentifier: String
    
    init(value: String = "SensorReading", key: String = "Type", operatorIdentifier: String = "EQUAL") {
        self.value = value
        self.key = key
        self.operatorIdentifier = operatorIdentifier
    }
    
    var jsonDictionary: [String : Any] {
        return [
            "value": value,
            "key": key,
            "operator": operatorIdentifier
        ]
    }
    
    func jsonString() throws -> String {
        if let jsonString = try String(data: json(), encoding: .ascii) {
            return jsonString
        } else {
            throw JSONError.stringConversationFailed
        }
    }
}
    
struct PredicateMap: JSON {
    let predicates: [Predicate]
    
    var jsonDictionary: [String : Any] {
        let predicatesStrings = predicates.map { try? $0.jsonString() }.flatMap { $0 }
        
        return [
            "predicateMap": predicatesStrings,
            "stringAttributeBorders": [:]
        ]
    }
}
