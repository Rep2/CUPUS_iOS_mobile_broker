enum Geometry: JSON {
    case point(x: Double, y: Double)
    
    var jsonDictionary: [String : Any] {
        switch self {
        case .point(let x, let y):
            return [
                "coordinates": [x, y],
                "type": "Point"
            ]
        }
    }
}
