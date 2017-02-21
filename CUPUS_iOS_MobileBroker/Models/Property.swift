enum Property: JSON {
    case co(value: Int)
    
    var id: String {
        switch self {
        case .co:
            return "10.0"
        }
    }
    
    var propertyIdentifier: String {
        switch self {
        case .co:
            return "co"
        }
    }
    
    var jsonDictionary: [String : Any] {
        switch  self {
        case .co(let value):
            return [
                "Type": "SensorReading",
                "ID": id,
                propertyIdentifier: String(value)
            ]
        }
    }
}
