
import Foundation

// 프로퍼티 관찰자 - KVO
// : Stored Property(저장 프로퍼티)의 값이 변경될 때 수행되는 블록을 지정할 수 있습니다.

// didSet
//  : 값이 변경된 후에 호출되는 블록입니다. - oldValue
//  => 값의 변경 이후로 추가적으로 수행해야 하는 작업이 있을 경우 사용합니다.

// willSet
//  : 값이 변경되기 직전에 호출되는 블록입니다. - newValue
//  => 속성이 변경되었다는 사실을 외부로 알릴 때 많이 사용합니다.
struct User {
  var email: String {
    didSet {
      print("didSet - \(oldValue)")

      // didSet / willSet 다시 호출하지 않습니다.
      email = email.lowercased().trimmingCharacters(in: .whitespaces)
    }

    willSet {
      print("willSet - \(newValue)")
    }
  }

  init(email: String) {
    self.email = email

    // defer: 함수가 종료되는 시점에 수행되는 블록입니다.
    //        함수의 마지막에 수행되어야 하는 정리 코드를 실행하려는 경우 유용하게 사용할 수 있습니다.
    defer {
      self.email = email
    }
  }
}

// 주의사항: 초기화메소드를 통해서 설정된 값에 대해서는 호출되지 않습니다.
//  => 해결방법
var user = User(email: " Hello@gmail.com ")
print(user.email)

user.email = "World@gmail.com"
print(user.email)
