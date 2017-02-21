@testable import CUPUS_iOS_MobileBroker
import Nimble
import XCTest

class PublisherComminicationTests: XCTestCase {
    
    func testPublisherRegister() {
        let delegate = ConnectionDelegate()
        let senderId = "030f6d80-0169-44f9-b639-2ed236949123"
        let message = BaseMessage(senderId: senderId,
                                  message: CUPUSMessages.registerPublisher(name: "test 1", senderId: senderId))
        
        let startTimea = Date().timeIntervalSince1970 * 1000
        let startTime = Int64(startTimea)
        let publicationMessage = BaseMessage(senderId: senderId,
                                             message: CUPUSMessages.publish(features: [Feature(geometry: .point(x: 45.815011, y: 15.981919), property: Property.co(value: 20))], startTime: startTime))
        
        do {
            _ = try Connection.connect(host: "127.0.0.1", port: 10000, delegate: delegate)
            let json = try message.json()
            
            waitUntil(timeout: 10) { done in
                delegate.write(data: json) {
                    expect(true).to(equal(true))
                    done()
                }
            }
            
            let publicationJson = try publicationMessage.json()
            
            waitUntil(timeout: 10) { done in
                delegate.write(data: publicationJson) {
                    expect(true).to(equal(true))
                    done()
                }
            }
        } catch {
            expect(true).to(equal(false))
        }
        
    }
    
}
