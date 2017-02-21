@testable import CUPUS_iOS_MobileBroker
import Nimble
import XCTest

class SubscribtionModelTests: XCTestCase {

    func testPredicate_JSON() {
        let predicate = Predicate()
        
        do {
            let jsonString = try String(data: predicate.json(), encoding: .ascii)
            
            expect(jsonString).to(equal("{\"key\":\"Type\",\"value\":\"SensorReading\",\"operator\":\"EQUAL\"}"))
        } catch {
            expect(true).to(beFalse())
        }
    }
    
    func testPredicateMap_JSON() {
        let predicateMap = PredicateMap(predicates: [Predicate()])
        
        do {
            let jsonString = try String(data: predicateMap.json(), encoding: .ascii)
            
            expect(jsonString).to(equal("{\"stringAttributeBorders\":{},\"predicateMap\":[\"{\\\"key\\\":\\\"Type\\\",\\\"value\\\":\\\"SensorReading\\\",\\\"operator\\\":\\\"EQUAL\\\"}\"]}"))
        } catch {
            expect(true).to(beFalse())
        }
    }
    
}
