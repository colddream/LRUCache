import Foundation

protocol LRUCacheable {
    associatedtype Key: Hashable
    associatedtype Value
    
    func set(value: Value, for key: Key)
    func getValue(for key: Key) -> Value?
    func removeLast()
    func removeAll()
}


public class LRUCache<Key: Hashable, Value>: LRUCacheable {
    struct CachePayload {
        let key: Key
        let value: Value
    }
    
    private let capacity: Int
    private let list = DoublyLinkedList<CachePayload>()
    private var nodesDict = [Key: DoublyLinkedList<CachePayload>.Node<CachePayload>]()
    
    private let lock = NSLock()
    
    public var count: Int {
        return nodesDict.count
    }
    
    public init(capacity: Int) {
        self.capacity = capacity
    }
    
    public func set(value: Value, for key: Key) {
        lock.lock()
        defer { lock.unlock() }
        
        // Create payload
        let payload = CachePayload(key: key, value: value)
        
        // Check if node exist or not
        if let node = nodesDict[key] {
            node.payload = payload
            list.moveToHead(node)
        } else {
            let node = list.addToHead(payload: payload)
            nodesDict[key] = node
        }
        
        // Check capacity
        if list.count > capacity {
            removeLast()
        }
    }
    
    public func getValue(for key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        
        guard let node = nodesDict[key] else {
            return nil
        }
        
        list.moveToHead(node)
        return node.payload.value
    }
    
    public func removeLast() {
        lock.lock()
        defer { lock.unlock() }
        
        let nodeToRemove = list.removeLast()
        if let key = nodeToRemove?.payload.key {
            nodesDict[key] = nil
        }
    }
    
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        
        list.removeAll()
        nodesDict.removeAll()
    }
    
    public func getHead() -> Value? {
        lock.lock()
        defer { lock.unlock() }
        
        return list.head?.payload.value
    }
    
    public func getTail() -> Value? {
        lock.lock()
        defer { lock.unlock() }
        
        return list.tail?.payload.value
    }
}

extension LRUCache.CachePayload: CustomStringConvertible {
    var description: String {
        return "\(self.value)"
    }
}

extension LRUCache: CustomStringConvertible {
    public var description: String {
        // Make order keys
        var orderKeys: [Key] = []
        var node = list.head
        while node != nil {
            orderKeys.append(node!.payload.key)
            node = node?.next
        }
        
        var message = orderKeys.map { "\(nodesDict[$0]!.payload.key): \(nodesDict[$0]!.payload.value)" }.joined(separator: ", ")
        message = "[\(message)]"
        
        message += "\n\(list)"
        return message
    }
}
