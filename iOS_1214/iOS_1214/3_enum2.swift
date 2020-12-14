
import Foundation

// enum - 타입 안정성

// 1. Any: 모든 타입을 참조할 수 있는 타입입니다.
//  1) as: 타입 변환
//  2) is: 타입 체크

// let arr: Array<Any> = [
#if false
let arr: [Any] = [
  Date(),
  "Hello",
  100,
  3.14
]

for element in arr {
  switch element {
  case let v as String:
    print("String - \(v)")
  case let v as Date:
    print("Date - \(v)")
  case let v as Int:
    print("Int - \(v)")
  case let v as Double:
    print("Double - \(v)")
  default:
    print("지원하지 않는 타입입니다.")
  }

  // 타입 체크만 필요할 때
  #if false
  switch element {
  case is String:
    print("String")
  case is Date:
    print("Date")
  case is Int:
    print("Int")
  case is Double:
    print("Double")
  default:
    print("지원하지 않는 타입입니다.")
  }
  #endif
}
#endif

// Date(),
// "Hello",
// 100,
// 3.14

enum DataType {
  case date(Date)
  case string(String)
  case int(Int)
  case double(Double)
  
  // 새로운 항목이 추가되면, 컴파일러가 오류를 통해 처리해야 하는 부분을 알려줍니다.
  case dateRange(Range<Date>)
}

let start = Date()
let end = Date().addingTimeInterval(10)

let arr: [DataType] = [
  .date(Date()),
  .string("Hello"),
  .int(100),
  .double(3.14),

  // start...end : [start, end] - ClosedRange
  // start..<end : [start, end) - Range
  .dateRange(start ..< end)
]

for element in arr {
  switch element {
  case let .date(v):
    print("date - \(v)")
  case let .string(v):
    print("string - \(v)")
  case let .int(v):
    print("int - \(v)")
  case let .double(v):
    print("double - \(v)")
  case let .dateRange(v):
    print("Range<Date> - \(v)")
  }
}
