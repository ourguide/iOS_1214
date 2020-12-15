
import Foundation

// Sequence 프로토콜을 구현하는 컬렉션은 다양한 기능을 사용할 수 있습니다.
//  - map: 데이터를 변환한다.
//  - sorted: 데이터를 정렬한다.
//  - filtered: 데이터를 필터한다.
//  - shuffled: 데이터를 섞는다.

//  - lazy: 대규모 데이터를 처리할 때 유용합니다.
//    1) 중첩된 클로저의 연산이 저장된다.
//    2) 순회를 수행할 때 마다 새롭게 결과가 처리된다.
#if false
let arr = 0 ..< Int.max

print("연산 시작")
let result = arr
  .filter { e -> Bool in
    e.isMultiple(of: 22)
  }.suffix(3)
print("연산 종료")

print(result)
#endif

let arr = 0 ..< Int.max

let result = arr
  .lazy
  .filter { e -> Bool in
    e.isMultiple(of: 22)
  }.suffix(3)

// for e in result {
//  print(e)
// }

// - reduce: 여러 요소를 통해 하나의 결과를 도출한다.
let text = """
hello
world
show
me
the
money

"""

let newlineCount = text.reduce(0) { (sum: Int, char: Character) -> Int in
  if char == "\n" {
    return sum + 1
  } else {
    return sum
  }
}

print(newlineCount)

let scores = [
  77,
  65,
  80,
  92,
  100,
  80,
  92,
  100,
  77,
]
// [ Character: Int ]
//  - "A": 3,
//    "B": 2
//     ....

// let a: [Int] = [ ]           // 빈 배열
// let b: [String: Any] = [:]   // 빈 사전

// 주의사항
//  : 요소의 개수가 많을 경우, temp = result 복사 비용이 증가할 수 있다.
let stat1 = scores.reduce([:]) { (result: [Character: Int], score: Int) -> [Character: Int] in
  var temp = result

  switch score {
  case 0 ..< 70:
    temp["D", default: 0] += 1
  case 70 ..< 80:
    temp["C", default: 0] += 1
  case 80 ..< 90:
    temp["B", default: 0] += 1
  case 90...:
    temp["A", default: 0] += 1
  default:
    break
  }

  return temp
}

print(stat1)

// 복사의 비용이 발생하지 않습니다.
// => 반환할 필요가 없습니다.
let stat2 = scores.reduce(into: [:]) { (result: inout [Character: Int], score: Int) in
  switch score {
  case 0 ..< 70:
    result["D", default: 0] += 1
  case 70 ..< 80:
    result["C", default: 0] += 1
  case 80 ..< 90:
    result["B", default: 0] += 1
  case 90...:
    result["A", default: 0] += 1
  default:
    break
  }
}

print(stat2)

// let a = []
// 1)
let a: [Int] = []
// 2)
let b = [Int]()

// let c = [:]

let c: [String: Int] = [:]
let d = [String: Int]()

print("---------")

// - zip
//  => 두 개의 반복자를 통해 데이터를 묶을 수 있습니다.
//     하나의 반복자가 종료되면, zip 연산은 중지 됩니다.

let numbers = 0 ..< 10
let grades = ["A", "B", "C", "D"]

for (number, grade) in zip(numbers, grades) {
  print("No \(number). \(grade)")
}
