
import Foundation

// 1. 요소의 빈도를 관리할 수 있는 Bag 구조체를 만들어봅시다.

struct Bag<Element: Hashable> {
  // private var store = [Element: Int]()
  private var store: [Element: Int] = [:]
  
  mutating func insert(_ element: Element) {
    store[element, default: 0] += 1
  }
  
  mutating func remove(_ element: Element) {
    store[element, default: 0] -= 1
    
    if store[element] == 0 {
      store[element] = nil
    }
  }
  
  var count: Int {
    return store.values.reduce(0, +)
  }
}

let text = """
hello, world
show me the money
"""

var bag1 = Bag<Character>()
for e in text {
  bag1.insert(e)
}

print(bag1.count)


var bag2 = Bag<String>()
let data = [ "Tom", "Bob", "Alice", "Alice", "Bob" ]

for e in data {
  bag2.insert(e)
}

print(bag2.count)
