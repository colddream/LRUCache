//
//  DoublyLinkedList.swift
//  
//
//  Created by Do Thang on 08/12/2022.
//

import Foundation

class DoublyLinkedList<T> {
    final class Node<T> {
        var payload: T
        var next: Node<T>?
        var prev: Node<T>?
        
        init(payload: T) {
            self.payload = payload
        }
    }
    
    private(set) var head: Node<T>?
    private(set) var tail: Node<T>?
    private(set) var count: Int = 0
    
    // New Node will add to head
    func addToHead(payload: T) -> Node<T> {
        let node = Node(payload: payload)
        defer {
            head = node
            count += 1
        }
        
        guard let head = self.head else {
            tail = node
            return node
        }
        
        node.next = head
        head.prev = node
        
        return node
    }
    
    func moveToHead(_ node: Node<T>) {
        guard node !== head else {
            return
        }
        
        let prev = node.prev
        let next = node.next
        
        // Link prev and next of node
        prev?.next = next
        next?.prev = prev
        
        // Move node to head
        node.next = head
        node.prev = nil
        head?.prev = node
        head = node
        
        // Check if node is tail
        if node === tail {
            self.tail = prev
        }
    }
    
    func removeLast() -> Node<T>? {
        guard let tail = self.tail else {
            return nil
        }
        
        let prev = tail.prev
        prev?.next = nil
        tail.prev = nil
        
        self.tail = prev
        
        if count == 1 {
            head = nil
        }
        
        count -= 1
        return tail
    }
    
    func removeAll() {
        head = nil
        tail = nil
        count = 0
    }
}

extension DoublyLinkedList.Node: CustomStringConvertible {
    var description: String {
        return "\(self.payload)"
    }
}

extension DoublyLinkedList: CustomStringConvertible {
    var description: String {
        var headToTail = ""
        var tailToHead = ""
        
        var node = self.head
        while node != nil {
            headToTail += "\(node!)"
            node = node?.next
            if node != nil {
                headToTail += " -> "
            }
        }
        
        node = self.tail
        while node != nil {
            tailToHead += "\(node!)"
            node = node?.prev
            if node != nil {
                tailToHead += " -> "
            }
        }
        
        return "Head -> Tail: " + headToTail + "\nTail -> Head: " + tailToHead
    }
}
