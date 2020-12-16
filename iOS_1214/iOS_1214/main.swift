
import Foundation

//                 Sequence
//                    |
//                Collection - []
//                    |
//      +-------------+------------------------------------+
//      |                     |                            |
// MutableCollection   RangeReplicationCollection    BidirectionCollection
//                                                         |
//                                                         |
//                                                   RandomAccessCollection

// 1) MutableCollection
//  : 길이를 변경하지 않고 요소의 값을 변경할 수 있는 연산을 제공한다.
//  - Array
//     : sort / partition
#if false
var arr = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
arr.sort()

let index = arr.partition { e -> Bool in
  e % 2 == 0
}

// print(arr)
// print(index)

print(arr[..<index]) // left
print(arr[index...]) // right

// 2) RangeReplicationCollection
//  - 범위를 바꾸고 길을 변경할 수 있는 연산을 제공한다.
//  - Array / String
//    : += / removeFirst / removeSubrance / removeAll

arr += [1, 2, 3]
print(arr)

arr.removeAll { (e) -> Bool in
  e % 2 == 0
}

print(arr)

// 3) BidirectionCollection
//  - 역방향으로 순회가 가능합니다.

// [startIndex, endIndex) - 반개 구간
var lastIndex = arr.endIndex // 포함되지 않습니다.
while lastIndex > arr.startIndex {
  lastIndex = arr.index(before: lastIndex)
  print(arr[lastIndex])
}

print("-----------")

// 실제 사용할 때는
for value in arr.reversed() {
  print(value)
}

// 4) RandomAccessCollection
//   - BidirectionCollection을 상속하며, 성능 향상을 제공합니다.
//     인덱스 간의 거리를 O(1)으로 처리할 수 있습니다.
//     Array / Repeated
print("-----------")
let repeated = repeatElement("hello", count: 10)
// for e in repeated {
//  print(e)
// }

print(repeated[3])

// --------------

// Collection 프로토콜을 만족하면, Sequence 프로토콜도 만족한다.
#endif

#if false
public protocol Collection: Sequence {
  associatedtype Element
  associatedtype Index

  var startIndex: Self.Index { get }
  var endIndex: Self.Index { get } // 끝 다음 인덱스

  subscript(position: Self.Index) -> Self.Element { get }

  func index(after i: Int) -> Self.Index
}
#endif

#if false
struct Fruits {
  let banana = "Banana"
  let apple = "Apple"
  let tomato = "Tomato"
}

extension Fruits: Collection {
  typealias Element = String
  typealias Index = Int

  var startIndex: Int {
    return 0
  }

  var endIndex: Int {
    return 3
  }

  subscript(position: Int) -> String {
    switch position {
    case 0: return banana
    case 1: return apple
    case 2: return tomato
    default:
      fatalError("없습니다!")
    }
  }

  func index(after i: Int) -> Int {
    return i + 1
  }
}

// Collection은 Sequence를 만족합니다.
let fruits = Fruits()
for e in fruits {
  print(e)
}

var result = fruits.map { text -> String in
  text.uppercased()
}

result = fruits.sorted()
print(result)
#endif

struct Activity {
  let date: Date
  let description: String
}

struct Day: Hashable {
  let date: Date

  // 시간 / 분 / 초에 대한 정보는 제외한다.
  init(date: Date) {
    let flags: Set<Calendar.Component> = [.year, .month, .day]
    let components = Calendar.current.dateComponents(flags, from: date)

    guard let convertedDate = Calendar.current.date(from: components) else {
      self.date = date
      return
    }

    self.date = convertedDate
  }
}

struct Diary {
  typealias DataType = [Day: [Activity]]

  var activities = DataType()
  //            groupBy
  // [Activity]    ->     [ Day: [Activity] ]
  init(activities: [Activity]) {
    //                                                             <key>
    self.activities = Dictionary(grouping: activities) { activity -> Day in
      Day(date: activity.date)
    }
  }
}

let activities = [
  Activity(date: Date(), description: "아침 식사"),
  Activity(date: Date(), description: "점심 식사"),
  Activity(date: Date(), description: "저녁 식사"),
  Activity(date: Date(), description: "야식"),
]

// let diary = Diary(activities: activities)
// dump(diary)

extension Diary: Collection {
  var startIndex: DataType.Index {
    return activities.keys.startIndex
  }

  var endIndex: DataType.Index {
    return activities.keys.endIndex
  }

  func index(after i: DataType.Index) -> DataType.Index {
    return activities.index(after: i)
  }

  subscript(position: DataType.Index) -> DataType.Element {
    return activities[position]
  }
}

let diary = Diary(activities: activities)

var startIndex = diary.startIndex
while startIndex < diary.endIndex {
  let e = diary[startIndex]
  dump("index: \(startIndex)")
  dump("value: \(e)")

  startIndex = diary.index(after: startIndex)
}

for (day, activities) in diary {
  dump(day)
  dump(activities)
}

