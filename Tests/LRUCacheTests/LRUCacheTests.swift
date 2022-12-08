import XCTest
@testable import LRUCache

final class LRUCacheTests: XCTestCase {
    let capacity: Int = 5
    var cache: LRUCache<String, String>!
    
    override func setUpWithError() throws {
        cache = LRUCache(capacity: capacity)
    }
    
    override func tearDownWithError() throws {
        cache = nil
    }
    
    func testLRUCache() throws {
        cache.set(value: "A", for: "Key1")
        
        XCTAssert(cache.count == 1)
        XCTAssert(cache.getHead() == cache.getTail())
        
        cache.set(value: "B", for: "Key2")
        cache.set(value: "C", for: "Key3")
        
        XCTAssert(cache.count == 3)
        
        cache.set(value: "D", for: "Key4")
        cache.set(value: "E", for: "Key5")
        cache.set(value: "F", for: "Key6")
        cache.set(value: "G", for: "Key4")
        
        XCTAssert(cache.count == 5)
        XCTAssert(cache.getValue(for: "Key1") == nil)
        XCTAssert(cache.getValue(for: "Key6") == "F")
        XCTAssert(cache.getValue(for: "Key4") == "G")
        XCTAssert(cache.getHead() == "G")
        XCTAssert(cache.getTail() == "B")
        
        cache.set(value: "B", for: "Key2")
        XCTAssert(cache.getHead() == "B")
        XCTAssert(cache.getTail() == "C")
        
        print(cache!)
        let expectedPrint = """
        [Key2: B, Key4: G, Key6: F, Key5: E, Key3: C]
        Head -> Tail: B -> G -> F -> E -> C
        Tail -> Head: C -> E -> F -> G -> B
        """
        XCTAssert(cache.description == expectedPrint)
        
        XCTAssert(cache.getTail() == "C")
        cache.removeLast()
        XCTAssert(cache.getTail() == "E")
        cache.removeLast()
        XCTAssert(cache.getTail() == "F")
        cache.removeLast()
        XCTAssert(cache.getTail() == "G")
        cache.removeLast()
        XCTAssert(cache.getTail() == "B")
        XCTAssert(cache.getHead() == cache.getTail())
        
        cache.removeAll()
        XCTAssert(cache.getHead() == nil)
        XCTAssert(cache.getTail() == nil)
        XCTAssert(cache.count == 0)
    }
}
