//
//  Dispatch.swift
//  BlueWhale2
//
//  Created by Chan Fai Chong on 14/8/15.
//  Copyright © 2015 Ignition Soft. All rights reserved.
//

import Foundation

public class Queue {
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

    public init(queue: dispatch_queue_t) {
        self.queue = queue
    }
    
    public init(label: String, type: QueueType = .Serial) {
        let labelBytes : UnsafePointer<Int8> = label.cStringUsingEncoding(NSUTF8StringEncoding)!.withUnsafeBufferPointer({
            $0.baseAddress
        })
        self.queue = dispatch_queue_create(labelBytes, type.value)
    }

    public func async(block: dispatch_block_t) {
        dispatch_async(self.queue, block)
    }
    
    public func sync(block: dispatch_block_t) {
        dispatch_sync(self.queue, block)
    }
    
    public func apply(iterations: Int, block: (Int) -> Void) {
        dispatch_apply(iterations, queue, block)
    }

    public func after(delayInSeconds: Double, block: dispatch_block_t) {
        let nanoSeconds = Int64(Double(NSEC_PER_MSEC) * delayInSeconds)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
        dispatch_after(delayTime, queue, block)
    }
    
    public static func main() -> Queue {
        return Queue(queue: dispatch_get_main_queue())
    }
    
    public static func concurrent(qos: Queue.QOS) -> Queue {
        return Queue(queue: dispatch_get_global_queue(qos.value, 0))
    }

    public static func concurrent(priority priority: Queue.Priority) -> Queue {
        return Queue(queue: dispatch_get_global_queue(priority.value, 0))
    }
}