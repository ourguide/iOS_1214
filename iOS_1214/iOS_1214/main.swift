
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
let data = ["Tom", "Bob", "Alice", "Alice", "Bob"]

for e in data {
  bag2.insert(e)
}

print(bag2.count)

// 구현 방법 1. 직접 반복자 타입을 정의하는 방법
#if false
struct BagIterator<Element: Hashable>: IteratorProtocol {
  var store = [Element: Int]()

  mutating func next() -> Element? {
    guard let (key, value) = store.first else {
      return nil
    }

    if value > 1 {
      store[key]? -= 1
    } else {
      store[key] = nil
    }

    return key
  }
}

extension Bag: Sequence {
  func makeIterator() -> BagIterator<Element> {
    return BagIterator(store: store)
  }
}
#endif

// 구현 방법 2. AnyIterator를 이용하는 방법
extension Bag: Sequence {
  func makeIterator() -> AnyIterator<Element> {
    var store = self.store

    return AnyIterator {
      guard let (key, value) = store.first else {
        return nil
      }

      if value > 1 {
        store[key]? -= 1
      } else {
        store[key] = nil
      }

      return key
    }
  }
}

print("------------")
for e in bag2 {
  print(e)
}

// 배열 리터럴을 지원하고 싶습니다. - ExpressibleByArrayLiteral
let bag3: Bag<Int> = [
  10, 20, 30, 40, 10, 30, 20, 40
]

extension Bag: ExpressibleByArrayLiteral {
  typealias ArrayLiteralElement = Element
  
  init(arrayLiteral elements: Element...) {
    store = elements.reduce(into: [:], { (store, element) in
      store[element, default: 0] += 1
    })
  }
}

print(bag3)
