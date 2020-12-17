import Foundation

// 프로토콜
// - 컴파일 타임 프로토콜 / 런타임 프로토콜

// 문제점
// 1) PAT를 사용하기 때문에, 런타임 프로토콜을 일반적으로는 사용이 불가능합니다.
// 2) 새로운 종류의 Validator를 필요로 할 때마다, 새로운 타입이 추가됩니다.

#if false
protocol Validator {
  associatedtype Value

  func validate(_ value: Value) -> Bool
}

struct MinimalCountValidator: Validator {
  let minimalCount: Int

  func validate(_ value: String) -> Bool {
    return minimalCount < value.count
  }
}

struct MaximumCountValidator: Validator {
  let maxCount: Int

  func validate(_ value: String) -> Bool {
    return maxCount >= value.count
  }
}

let validator = MinimalCountValidator(minimalCount: 5)
let v2 = MaximumCountValidator(maxCount: 10)

let result = validator.validate("hellox")
let result2 = v2.validate("xxxx")

print(result)
#endif

// Generic Struct 버전
struct Validator<T> {
  let validate: (T) -> Bool // 함수

  init(validate: @escaping (T) -> Bool) {
    self.validate = validate
  }
}

let minValidator = Validator { (e: String) in
  e.count > 5
}

let maxValidator = Validator { (e: String) in
  e.count <= 10
}

// let result = minValidator.validate("hello")
// let result2 = maxValidator.validate("hello")
// print(result)
// print(result2)

let validator = minValidator.combine(maxValidator)
let result = validator.validate("helloworld")

print(result)

extension Validator {
  func combine(_ other: Validator<T>) -> Validator<T> {
    return Validator<T> { e in
      let result1 = validate(e)
      let result2 = other.validate(e)

      return result1 && result2
    }
  }
}

// -----------------------------------------------------
//      요구 사항             |         접근 방법
// -----------------------------------------------------
//      가벼운 다형성          |           enum
//                         |
//  다양한 타입과 동작해야 한다.  |           generic type
//                         |
//  정책의 변화가 필요한 타입이   |           클로저를 저장한 타입
//  필요하다(Validator)      |
//                         |
//  복잡한 다형성, 기본 구현     |           protocol
