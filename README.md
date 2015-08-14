# SwiftyDispatch

A lightweight GCD wrapper for Swift.

[![Version](https://img.shields.io/cocoapods/v/SwiftyDispatch.svg?style=flat)](http://cocoapods.org/pods/SwiftyDispatch)
[![License](https://img.shields.io/cocoapods/l/SwiftyDispatch.svg?style=flat)](http://cocoapods.org/pods/SwiftyDispatch)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyDispatch.svg?style=flat)](http://cocoapods.org/pods/SwiftyDispatch)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Create queues

```swift
// Create a serial queue
let queue = Queue("Serial", .Serial)

// Create a concurrent queue
let queue = Queue("Concurrent", .Concurrent)

// It is serial by default
let queue = Queue("Concurrent")

// Get main queue
let queue = Queue.main()

// Get global queue via QOS
let queue = Queue.concurrent(.UserInteractive)

// Get global queue via priority
let queue = Queue.concurrent(priority: .Background)

```

### Run blocks

```swift
// asynchronously
queue.async {
  data = true
}

// synchronously
queue.sync {
  data = true
}

```

### Apply

```swift
queue.apply(10) {
  // some concurrent task
}
```

### After

```swift
queue.apply(0.3) {
  // run after 0.3 seconds
}
```

## Requirements

- Swift 2.0 (Xcode 7)

## Installation

Dispatch is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftyDispatch"
```

## TODO?

- [x] Queue
- [x] Async/Sync
- [x] Apply
- [x] After
- [ ] Barrier
- [ ] Group
- [ ] Semaphore
- [ ] Source
- [ ] Block class

## Author

Francis Chong, francis@ignition.hk

## License

Dispatch is available under the MIT license. See the LICENSE file for more info.
