
import Foundation

// enum - 타입 안정성

// 1. Any: 모든 타입을 참조할 수 있는 타입입니다.
//  1) as: 타입 변환
//  2) is: 타입 체크

// let arr: Array<Any> = [

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
