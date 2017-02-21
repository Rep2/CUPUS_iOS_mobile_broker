@testable import CUPUS_iOS_MobileBroker
import Nimble
import XCTest

class SubscriberTest: XCTestCase {
    
    func testRegisterSubscriber() {
        let delegate = ConnectionDelegate()
        let senderId = "030f6d80-0169-44f9-b639-2ed2361239123"
        let message = BaseMessage(senderId: senderId,
                                  message: CUPUSMessages.registerSubscriber(name: "test subscriber", ip: "192.168.1.14", port: 0, senderId: senderId))
        
        do {
            _ = try Connection.connect(host: "127.0.0.1", port: 10000, delegate: delegate)
            let json = try message.json()
            
            waitUntil(timeout: 10) { done in
                delegate.write(data: json) {
                    expect(true).to(equal(true))
                    done()
                }
            }
        } catch {
            expect(true).to(beFalse())
        }
    }
    
    func testSubscribe() {
        
        let delegate = ConnectionDelegate()
        let senderId = "030f6d80-0169-44f9-b639-2ed2361239123"
        let message = BaseMessage(senderId: senderId,
                                  message: .registerSubscriber(name: "test subscriber", ip: "192.168.1.14", port: 0, senderId: senderId))
        
        let startTime = Int64(Date().timeIntervalSince1970)
        let subscribeMessage = BaseMessage(senderId: senderId,
                                           message: .subscribe(features: [Feature(geometry: nil, property: PredicateMap(predicates: [Predicate()]))], startTime: startTime))
        
        do {
            _ = try Connection.connect(host: "127.0.0.1", port: 10000, delegate: delegate)
            let json = try message.json()
            
            waitUntil(timeout: 10) { done in
                delegate.write(data: json) {
                    expect(true).to(equal(true))
                    done()
                }
            }
            
            let subscribeJson = try subscribeMessage.json()
            
            waitUntil(timeout: 10) { done in
                delegate.write(data: subscribeJson) {
                    expect(true).to(equal(true))
                    done()
                }
            }
        } catch {
            expect(true).to(beFalse())
        }
    }
    
}

