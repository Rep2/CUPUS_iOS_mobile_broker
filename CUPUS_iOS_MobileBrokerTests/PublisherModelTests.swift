@testable import CUPUS_iOS_MobileBroker
import Nimble
import XCTest

class PublisherModelTests: XCTestCase {
    
    func testRegisterMessage_JSON() {
        let senderId = "030f6d80-0169-44f9-b639-2ed236949b74"
        let message = CUPUSMessages.registerPublisher(name: "test 1", senderId: senderId)
        
        let expectedJSON = "{\"id\":\"030f6d80-0169-44f9-b639-2ed236949b74\",\"en\":\"test 1\"}"
        
        do {
            let json = try message.json()
            let result = String(data: json, encoding: .ascii)
            
            expect(result).to(equal(expectedJSON))
        } catch {
            expect(true).to(beFalse())
        }
    }
    
    func testPublishMessage_JSON() {
        let startTime = Int64(Date().timeIntervalSince1970)
        let message = Publication(features: [Feature(geometry: .point(x: 100, y: 200), property: Property.co(value: 20))],
                                  startTime: startTime)
        
        expect(message.jsonDictionary["payload"] as? [String: Any]).toNot(beNil())
        expect(message.jsonDictionary["startTime"] as? Int64).to(equal(startTime))
        expect(message.jsonDictionary["validity"] as? Int).to(equal(-1))
    }
    
    func testProperty_JSON() {
        let property = Property.co(value: 20)
        
        expect(property.jsonDictionary as? [String: String]).to(equal([
            "Type": "SensorReading",
            "ID": "10.0",
            "co": "20"
            ])
        )
    }
    
    func testPointGeometry_JSON() {
        let point = Geometry.point(x: 100, y: 200)
        
        expect(point.jsonDictionary["coordinates"] as? [Double]).to(equal([100, 200]))
        expect(point.jsonDictionary["type"] as? String).to(equal("Point"))
    }
    
    func testFeature_JSON() {
        let geometry = Geometry.point(x: 100, y: 200)
        let co = Property.co(value: 20)
        let feature = Feature(geometry: geometry, property: co)
        
        expect(feature.jsonDictionary["type"] as? String).to(equal("Feature"))
        expect(feature.jsonDictionary["geometry"] as? [String: Any]).toNot(beNil())
        expect(feature.jsonDictionary["properties"] as? [String: Any]).toNot(beNil())
    }
    
    func testFeatures_JSON() {
        let geometry = Geometry.point(x: 100, y: 200)
        let co = Property.co(value: 20)
        let feature = Feature(geometry: geometry, property: co)
        
        let features = Feature.featuresToJSON(features: [feature])
        
        expect(features["type"] as? String).to(equal("FeatureCollection"))
        expect(features["features"] as? [[String: Any]]).toNot(beNil())
    }
    
}
