import UIKit
import XCTest
import SwiftyDispatch
import Nimble

class SwiftyDispatchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreate() {
        let queue = Queue(label: "test", type: .Serial)
        expect(queue.label).to(equal("test"))
        
        let concurrent = Queue(label: "concurrent", type: .Concurrent)
        expect(concurrent.label).to(equal("concurrent"))
        
        let defaultQueue = Queue(label: "defaultQueue")
        expect(defaultQueue.label).to(equal("defaultQueue"))
        
    }

    func testMain() {
        let queue = Queue.main()
        expect(queue.label).to(equal("com.apple.main-thread"))        
    }
    
    func testConcurrent() {
        let queue = Queue(qos: Queue.QOS.UserInitiated)
        expect(queue).toNot(beNil())
        expect(queue.label).to(contain("user-initiated"))
        
        let queue2 = Queue(priority: Queue.Priority.Background)
        expect(queue2).toNot(beNil())
        expect(queue2.label).to(contain("background"))
    }
    
    func testAsync() {
        var data : Bool = false
        let queue = Queue(label: "test")
        queue.async { () -> Void in
            data = true
        }
        expect(data).toEventually(beTrue())
    }

    func testSync() {
        var data : Bool = false
        let queue = Queue(label: "test")
        queue.sync { () -> Void in
            data = true
        }
        expect(data).toEventually(beTrue())
    }
    
    func testAfter() {
        let begin = NSDate()
        var data : Bool = false
        let queue = Queue(label: "test")

        queue.after(0.1) { () -> Void in
            data = true
        }

        expect(data).toEventually(beTrue())
        expect(begin.timeIntervalSinceNow).toEventually(beLessThanOrEqualTo(-0.1))
    }
    
    func testApply() {
        let queue = Queue(qos: .UserInteractive)
        var stack : [Int] = []

        queue.apply(5) { (i) -> Void in
            objc_sync_enter(queue)
            stack.append(i)
            objc_sync_exit(queue)
        }
        
        expect(stack.count).toEventually(equal(5))
    }
    
}
