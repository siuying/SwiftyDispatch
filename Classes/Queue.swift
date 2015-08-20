//
//  Dispatch.swift
//  BlueWhale2
//
//  Created by Chan Fai Chong on 14/8/15.
//  Copyright © 2015 Ignition Soft. All rights reserved.
//

import Foundation

public struct Queue {
    public let queue : dispatch_queue_t
    
    public enum QueueType {
        case Serial
        case Concurrent
        var value : dispatch_queue_attr_t? {
            get {
                switch self {
                case .Serial:
                    return DISPATCH_QUEUE_SERIAL
                case .Concurrent:
                    return DISPATCH_QUEUE_CONCURRENT
                }
            }
        }
    }

    public enum Priority : Int {
        case Background
        case Default
        case High
        case Low

        var value : Int {
            get {
                switch self {
                case .Background:
                    return DISPATCH_QUEUE_PRIORITY_BACKGROUND
                case .Default:
                    return DISPATCH_QUEUE_PRIORITY_DEFAULT
                case .High:
                    return DISPATCH_QUEUE_PRIORITY_HIGH
                case .Low:
                    return DISPATCH_QUEUE_PRIORITY_LOW
                }
            }
        }
    }

    public enum QOS : UInt {
        case UserInteractive
        case UserInitiated
        case Default
        case Utility
        case Background

        var value : qos_class_t {
            get {
                switch self {
                case .UserInteractive:
                    return QOS_CLASS_USER_INTERACTIVE
                case .UserInitiated:
                    return QOS_CLASS_USER_INITIATED
                case .Default:
                    return QOS_CLASS_DEFAULT
                case .Utility:
                    return QOS_CLASS_UTILITY
                case .Background:
                    return QOS_CLASS_BACKGROUND
                }
            }
        }
    }

    public var label : String {
        get {
            return String.fromCString(dispatch_queue_get_label(queue))!
        }
    }

    /// Create a Queue object with a dispatch_queue_t
    ///
    /// - Parameter queue: underlying dispatch_queue_t object
    public init(queue: dispatch_queue_t) {
        self.queue = queue
    }

    /// Create a Queue with label and type
    ///
    /// - Parameter label: label of the queue
    /// - Parameter type: Type of the queue (QueueType)
    public init(_ label: String, _ type: QueueType = .Serial) {
        self.queue = dispatch_queue_create(label, type.value)
    }

    /// Run a block asynchronously
    ///
    /// - Parameter block: The block to run
    public func async(block: dispatch_block_t) {
        dispatch_async(self.queue, block)
    }

    /// Run a block synchronously
    ///
    /// - Parameter block: The block to run
    public func sync(block: dispatch_block_t) {
        dispatch_sync(self.queue, block)
    }

    /// Submits a block to run for multiple times.
    ///
    /// - Parameter iterations: Number of iterations
    /// - Parameter block: The block to run
    public func apply(iterations: Int, block: (Int) -> Void) {
        dispatch_apply(iterations, queue, block)
    }

    /// Schedule a block at a specified time.
    ///
    /// - Parameter delayInSeconds: Delay in number of seconds
    /// - Parameter block: The block to run
    public func after(delayInSeconds: Double, block: dispatch_block_t) {
        let nanoSeconds = Int64(Double(NSEC_PER_SEC) * delayInSeconds)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
        dispatch_after(delayTime, queue, block)
    }

    /// Returns the default queue that is bound to the main thread.
    public static func main() -> Queue {
        return Queue(queue: dispatch_get_main_queue())
    }

    /// Returns a global queue by QOS
    /// - Parameter qos: the QOS of the queue
    public static func concurrent(qos: Queue.QOS) -> Queue {
        return Queue(queue: dispatch_get_global_queue(qos.value, 0))
    }

    /// Returns a global queue by Priotity
    /// - Parameter priority: the priority of the queue
    public static func concurrent(priority priority: Queue.Priority) -> Queue {
        return Queue(queue: dispatch_get_global_queue(priority.value, 0))
    }
}