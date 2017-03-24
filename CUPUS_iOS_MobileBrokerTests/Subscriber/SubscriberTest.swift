import XCTest
import Nimble
@testable import CUPUS_iOS_MobileBroker

class SubscriberTest: XCTestCase {

    var subscriber: Subscriber!

    override func setUp() {
        subscriber = Subscriber(ip: "192.168.1.8", port: 10000)
    }

    func testConnect() {
        waitUntil(timeout: 10) { done in
            self.subscriber.connect(callback: { result in
                switch result {
                case .success(let value):
                    expect(value).to(beTrue())
                case .failure(let error):
                    print(error)
                    expect(true).to(beFalse())
                }

                done()
            })
        }
    }

    func testRegister() {
        waitUntil(timeout: 10) { done in
            self.subscriber.connect(callback: { result in
                switch result {
                case .success:

                    self.subscriber.registerSubscriber(name: "Test subscriber", callback: { result in
                        switch result {
                        case .success(let value):
                            expect(value).to(beTrue())
                        case .failure(let error):
                            print(error)
                            expect(true).to(beFalse())
                        }

                        done()
                    })

                case .failure(let error):
                    print(error)
                    expect(true).to(beFalse())
                }
            })
        }
    }

    func testSubscribe() {
        waitUntil(timeout: 30) { done in
            self.subscriber.connect(callback: { result in
                switch result {
                case .success:

                    self.subscriber.registerSubscriber(name: "Test subscriber2", callback: { result in
                        switch result {
                        case .success:

                            self.subscriber.subscribe(geometry: Geometry.point(x: 45.815011, y: 15.981919), predicates: [Predicate(value: "SensorReading", key: "Type", predicateOperator: .equal)], callback: { result in

                                switch result {
                                case .success(let value):
                                    print("Subscribed")
                                case .failure(let error):
                                    print(error)
                                    expect(true).to(beFalse())
                                }


                            }, newPublicationCallback: { bytes in
                                print(bytes)

                                expect(true).to(beTrue())

                                done()
                            })

                        case .failure(let error):
                            print(error)
                            expect(true).to(beFalse())
                        }
                    })

                case .failure(let error):
                    print(error)
                    expect(true).to(beFalse())
                }
            })
        }
    }
}
