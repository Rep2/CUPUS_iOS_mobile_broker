struct Feature: JSON {
    let geometry: Geometry?
    let property: JSON
    
    init(geometry: Geometry? = nil, property: JSON) {
        self.geometry = geometry
        self.property = property
    }
    
    var jsonDictionary: [String : Any] {
        var json: [String : Any] = [
           "type": "Feature",
           "properties": property.jsonDictionary
        ]
        
        json["geometry"] = geometry?.jsonDictionary
        
        return json
    }
    
    static func featuresToJSON(features: [Feature]) -> [String : Any] {
        return [
            "features": features.map { $0.jsonDictionary },
            "type": "FeatureCollection"
        ]
    }
}
