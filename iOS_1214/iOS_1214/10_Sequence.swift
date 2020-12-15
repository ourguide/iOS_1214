
import Foundation

let names = ["Tom", "Bob", "Alice"]
for name in names {
  print(name)
}

// 위의 코드는 아래와 동일한 표현입니다.
// - Iterator
print("-------")

var iterator = names.makeIterator()
// 데이터를 전달하고, 다음 요소로 이동합니다.
// 데이터가 없을 경우 nil을 반환합니다.
while let name = iterator.next() {
  print(name)
}

print("--------")

// 사용자가 설계한 자료구조를 순회하기 위해서는,
//  두 개의 프로토콜을 이해해야 합니다.
//  - 컬렉션을 순회하는 객체에 대한 프로토콜    - IteratorProtocol => SingleListIterator
//  - 컬렉션에서 반복자를 꺼낼 수 있는 프로토콜  - Sequence

class Node<E> {
  var value: E
  var next: Node<E>?

  init(value: E, next: Node<E>?) {
    self.value = value
    self.next = next
  }
}

// SingleList를 순회하는 객체 - IteratorProtocol
#if false
public protocol IteratorProtocol {
  associatedtype Element
  mutating func next() -> Self.Element?
}
#endif

struct SingleListIterator<E>: IteratorProtocol {
  var current: Node<E>?

  typealias Element = E

  mutating func next() -> E? {
    defer {
      current = current?.next
    }

    return current?.value
  }

  init(_ current: Node<E>?) {
    self.current = current
  }
}

#if false
public protocol Sequence {
  associatedtype Iterator: IteratorProtocol

  func makeIterator() -> Self.Iterator
}
#endif

struct SingleList<E>: Sequence {
  // -----
  func makeIterator() -> SingleListIterator<E> {
    return SingleListIterator(head)
  }

  typealias Iterator = SingleListIterator<E>
  // -----

  var head: Node<E>?

  mutating func append(_ element: E) {
    head = Node(value: element, next: head)
  }

  func firstElement() -> E? {
    return head?.value
  }
}

var list = SingleList<Int>()
list.append(10)
list.append(20)
list.append(30)

// if let value = list.firstElement() {
//  print(value)
// }

var iterator2 = list.makeIterator()
print(type(of: iterator2))
while let value = iterator2.next() {
  print(value)
}

print("--------")
for value in list {
  print(value)
}

// Sequence / IteratorProtocol을 만족하면 다양한 기능을 사용할 수 있습니다.
let arr = list.sorted()
print(arr)

list.forEach { (e) in
  print(e)
}

let result = list.map { e in
  return e * 10
}
print(result)

let result2 = list.filter { e -> Bool in
  e % 4 == 0
}
print(result2)


