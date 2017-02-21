struct Publication: JSON {
    let features: [Feature]
    let startTime: Int64
    
    init(features: [Feature], startTime: Int64) {
        self.features = features
        self.startTime = startTime
    }
    
    var jsonDictionary: [String : Any] {
        return [
            "payload": Feature.featuresToJSON(features: features),
            "startTime": startTime,
            "validity": -1
        ]
    }
}
