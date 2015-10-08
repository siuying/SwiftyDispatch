import UIKit
import XCTest
import SwiftyDispatch
import Nimble

class QueueDispatchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreate() {
        let queue = Queue("test", .Serial)
        expect(queue.label).to(equal("test"))
        
        let concurrent = Queue("concurrent", .Concurrent)
        expect(concurrent.label).to(equal("concurrent"))
        
        let defaultQueue = Queue("defaultQueue")
        expect(defaultQueue.label).to(equal("defaultQueue"))
        
    }

    func testMain() {
        let queue = Queue.main()
        expect(queue.label).to(equal("com.apple.main-thread"))        
    }
    
    func testConcurrent() {
        let queue = Queue.concurrent(.UserInitiated)
        expect(queue).toNot(beNil())
        expect(queue.label).to(contain("user-initiated"))
        
        let queue2 = Queue.concurrent(priority: .Background)
        expect(queue2).toNot(beNil())
        expect(queue2.label).to(contain("background"))
    }
    
    func testAsync() {
        var data : Bool = false
        let queue = Queue("test")
        queue.async { () -> Void in
            data = true
        }
        expect(data).toEventually(beTrue())
    }

    func testSync() {
        var data : Bool = false
        let queue = Queue("test")
        queue.sync { () -> Void in
            data = true
        }
        expect(data).toEventually(beTrue())
    }
    
    func testAfter() {
        let begin = NSDate()
        var data : Bool = false
        let queue = Queue.main()

        queue.after(0.1) {
            data = true
            expect(begin.timeIntervalSinceNow).to(beLessThanOrEqualTo(-0.1))
        }

        expect(data).toEventually(beTrue())
    }
    
    func testApply() {
        let queue = Queue("queue")
        var stack : [Int] = []

        queue.apply(5) { (i) -> Void in
            stack.append(i)
        }
        
        expect(stack.count).toEventually(equal(5))
        expect(stack).toEventually(equal([0,1,2,3,4]))
    }
    
    func testTargetQoS() {
        var data : Bool = false
        let queue = Queue("test", .Serial)
        queue.setTargetQoS(Queue.QOS.Background)
        queue.async { () -> Void in
            data = true
        }
        expect(data).toEventually(beTrue())
    }
    
    func testTargetPriority() {
        var data : Bool = false
        let queue = Queue("test", .Serial)
        queue.setTargetPriority(Queue.Priority.Background)
        queue.async { () -> Void in
            data = true
        }
        expect(data).toEventually(beTrue())
    }
    
}
