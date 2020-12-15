
import Foundation

// 배열의 최소값을 찾는 함수 - Generic
// 1) 일반 타입으로 먼저 작성해보면 좋습니다.

#if false
func lowest(_ array: [Int]) -> Int? {
  // 1) 오름차순 정렬
  let sorted = array.sorted { (lhs, rhs) -> Bool in
    lhs < rhs
  }

  // 2) 오름차순 정렬된 배열의 첫번째 원소 반환
  return sorted.first
}

let arr = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
if let result = lowest(arr) {
  print(result)
}
#endif

// 오류의 원인: T는 모든 타입이 될 수 있기 때문에,
//           T가 비교가 불가능할 수도 있습니다.

// 해결방법: 제네릭 타입 T에 대한 제약사항 정의해야 합니다.
//    비교 - Comparable(protocol)
//    => T가 Comparable을 만족해야 한다.

// 표시 방법 1.
//   <T: Comparable>
#if false
func lowest<T: Comparable>(_ array: [T]) -> T? {
  // 1) 오름차순 정렬
  let sorted = array.sorted { (lhs, rhs) -> Bool in
    lhs < rhs
  }

  // 2) 오름차순 정렬된 배열의 첫번째 원소 반환
  return sorted.first
}
#endif

// 표시 방법 2.
//   where T: Comparable
func lowest<T>(_ array: [T]) -> T? where T: Comparable {
  return array.sorted().first
}

#if false
let arr = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
if let result = lowest(arr) {
  print(result)
}

let arr2 = ["hello", "world", "abcd"]
if let result = lowest(arr2) {
  print(result)
}

struct User: Comparable {
  let name: String
  let age: Int

  static func < (lhs: User, rhs: User) -> Bool {
    // return lhs.age < rhs.age
    return lhs.name < rhs.name
  }
}

let arr3 = [
  User(name: "Tom", age: 42),
  User(name: "Bob", age: 35),
  User(name: "Zlice", age: 17),
]

// Global function 'lowest' requires that 'User' conform to 'Comparable'
if let result = lowest(arr3) {
  print(result)
}

enum School {
  case high
  case elementary
  case middle
}

let arr4: [School] = [
  .high,
  .middle,
  .elementary,
  .middle,
  .high,
  .elementary,
]

// Comparable의 구현을 제공하지 않을 경우, 순서에 따라서 자동으로 결정됩니다.
extension School: Comparable {
  static func < (lhs: School, rhs: School) -> Bool {
    switch (lhs, rhs) {
    case (elementary, middle):
      return true
    case (elementary, high):
      return true
    case (middle, high):
      return true
    default:
      return false
    }
  }
}

if let result = lowest(arr4) {
  print(result)
}
#endif

// 정렬된 값을 출력하고, 값의 발생 빈도를 출력합니다.
#if false
func printValues(_ values: [String]) {
  print(values.sorted())

  var result = [String: Int]()
  for e in values {
    let v = result[e] ?? 0
    result[e] = v + 1
  }

  print(result)
}
#endif

// 제약을 여러개 지정하는 것도 가능합니다.
// func printValues<T: Comparable & Hashable>(_ values: [T]) {
func printValues<T>(_ values: [T]) where T: Comparable & Hashable {
  print(values.sorted())

  var result = [T: Int]()
  for e in values {
    let v = result[e] ?? 0
    result[e] = v + 1
  }

  print(result)
}

// Java(Kotlin)에서는 Map의 Key로 사용하기 위해서는
// 두 개의 메소드가 중요합니다.
//  - hashCode
//  - equals

// => Hashable 프로토콜은 Equatable 프로토콜을 포함합니다.

struct User: Comparable, Hashable {
  let name: String
  let age: Int

  static func < (lhs: User, rhs: User) -> Bool {
    return lhs.name < rhs.name
  }

  // 구조체는 Hashable / Equtable 을 자동으로 제공해줍니다.
  // => 내부의 프로퍼티가 Hashsable / Equtable을 만족해야 한다.
  #if false
  // hash 제공하는 것도 가능합니다.
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(age)
  }

  static func == (lhs: User, rhs: User) -> Bool {
    return lhs.name == rhs.name && lhs.age == rhs.age
  }
  #endif
}

let arr = [
  "hello",
  "world",
  "show",
  "me",
  "hello",
  "world",
]

printValues(arr)

let arr2 = [
  User(name: "Tom", age: 42),
  User(name: "Bob", age: 35),
  User(name: "Zlice", age: 17),
]

printValues(arr2)

struct Pair<T: Hashable, U: Hashable>: Hashable {
  let left: T
  let right: U

  init(_ left: T, _ right: U) {
    self.left = left
    self.right = right
  }
}

let pair = Pair("Tom", 42)
let dic = [pair: "User"]

print(pair)
print(dic)
