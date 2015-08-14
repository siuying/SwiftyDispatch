//
//  Semaphore.swift
//  Pods
//
//  Created by Chan Fai Chong on 14/8/15.
//
//

import Foundation

public struct Semaphore {
    let semaphore : dispatch_semaphore_t

    ///
    /// Create a semaphore with given initial value, default 0
    /// - Parameter value: initial value of semaphore
    ///
    public init(_ value: Int = 0) {
        semaphore = dispatch_semaphore_create(value)
    }

    /// Wait (decrement) for a semaphore.
    ///
    /// Decrement the counting semaphore. If the resulting value is less than zero,
    /// this function waits for a signal to occur before returning.
    ///
    /// - Parameter time: Time to wait in second
    /// - Returns: True on success, or false if the timeout occurred.
    public func wait(time: NSTimeInterval) -> Bool {
        let nanoSeconds = Int64(Double(NSEC_PER_MSEC) * time)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
        return dispatch_semaphore_wait(semaphore, delayTime) == 0
    }


    /// Wait (decrement) for a semaphore.
    ///
    /// Decrement the counting semaphore. If the resulting value is less than zero,
    /// this function waits for a signal to occur before returning.
    ///
    /// - Returns: True on success, or false if the timeout occurred.
    public func wait() -> Bool {
        return dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) == 0
    }
    
    public func signal() {
        dispatch_semaphore_signal(semaphore)
    }
}