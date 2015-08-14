//
//  SemaphoreTests.swift
//  Dispatch
//
//  Created by Chan Fai Chong on 14/8/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation

import XCTest
import SwiftyDispatch
import Nimble

class SemaphoreDispatchTests: XCTestCase {
    func testCreate() {
        let queue = Queue("sample")
        let semaphore = Semaphore(0)

        var data = false
        let begin = NSDate()

        queue.after(0.1) { () -> Void in
            data = true
            semaphore.signal()
        }
        semaphore.wait()

        expect(data).to(beTrue())
        expect(begin.timeIntervalSinceNow).to(beLessThanOrEqualTo(-0.1))
    }

}
