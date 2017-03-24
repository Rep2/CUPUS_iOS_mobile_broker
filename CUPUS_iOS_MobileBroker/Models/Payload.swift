import Foundation

struct Payload: JSON {
    let geometry: Geometry?
    let properties: [JSON]
    let startTime: Int64
    let validity: Int64

    init(geometry: Geometry? = nil, properties: [JSON], startTime: Int64, validity: Int64) {
        self.geometry = geometry
        self.properties = properties
        self.startTime = startTime
        self.validity = validity
    }

    init(geometry: Geometry? = nil, properties: [JSON], startDate: Date? = nil, endDate: Date? = nil) {
        self.geometry = geometry
        self.properties = properties

        if let startDate = startDate {
            self.startTime = Int64(startDate.timeIntervalSince1970 * 1000)
        } else {
            self.startTime = Int64(Date().timeIntervalSince1970 * 1000)
        }

        if let endDate = endDate {
            self.validity = Int64(endDate.timeIntervalSince1970 * 1000)
        } else {
            self.validity = -1
        }
    }
    
    var jsonDictionary: [String : Any] {
        var jsonDictionary: [String : Any] = [
            "startTime": startTime,
            "validity": validity,
            "properties": properties.map { $0.jsonDictionary }
        ]

        jsonDictionary["geometry"] = geometry?.jsonDictionary

        return jsonDictionary
    }
}
