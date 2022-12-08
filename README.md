
# Introduction

**LRUCache** is an open-source replacement for [`NSCache`](https://developer.apple.com/library/mac/documentation/cocoa/reference/NSCache_Class/Reference/Reference.html) that behaves in a predictable, debuggable way. **LRUCache** is an LRU (Least-Recently-Used) cache, meaning that objects will be discarded oldest-first based on the last time they were accessed. **LRUCache** will automatically empty itself in the event of a memory warning.


# Installation

LRUCache is packaged as a dynamic framework that you can import into your Xcode project. You can install this manually, or by using Swift Package Manager.

**Note:** LRUCache requires Xcode 10+ to build, and runs on iOS 10+ or macOS 10.12+.

To install using Swift Package Manage, add this to the `dependencies:` section in your Package.swift file:

```swift
.package(url: "httpshttps://github.com/colddream/LRUCache", .upToNextMinor(from: "1.0.0")),
```


# Usage

You can create an instance of **LRUCache** as follows:

```swift
let cache = LRUCache<String, Int>(capacity: capacity)
```

This would create a cache of unlimited size, containing `Int` values keyed by `String`. To add a value to the cache, use:

```swift
cache.set(value: 11, for: "Key1")
```

To fetch a cached value, use:

```swift
let value = cache.getValue(for: "Key1") // Returns nil if value not found
```

And you can remove all values at once with:

```swift
cache.removeAll()
```
