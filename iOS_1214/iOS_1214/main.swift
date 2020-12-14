import Foundation

// '상속'을 대체할 수 있습니다.
#if false
struct User {
  let email: String
  let password: String
  let joinDate: Date

  var level: Int
  var exp: Int
}

struct Admin {
  let email: String
  let password: String
  let joinDate: Date

  var logs: [String]
}
#endif

// 위의 코드는 중복된 속성이 존재합니다.
// - 객체지향 프로그래밍에서는 중복된 속성을 부모 클래스를 통해 캡슐화할 수 있습니다.
// 문제점
// - 스위프트에서 상속을 이용하기 위해서는 구조체가 아닌 클래스를 이용해야 합니다.

// 클래스
// - 구조체와 다르게 멤버 초기화 메소드가 자동으로 제공되지 않습니다.
// - 사용자는 반드시 초기화 메소드를 직접 정의해야 합니다.

#if false
class Account {
  let email: String
  let password: String
  let joinDate: Date

  init(email: String, password: String, joinDate: Date) {
    self.email = email
    self.password = password
    self.joinDate = joinDate
  }
}

class User: Account {
  var level: Int
  var exp: Int

  // 자신의 속성을 먼저 초기화하고, 부모의 초기화 메소드를 이용해서 초기화를 수행합니다.
  init(email: String, password: String, joinDate: Date, level: Int, exp: Int) {
    self.level = level
    self.exp = exp

    super.init(email: email, password: password, joinDate: joinDate)
  }
}

class Admin: Account {
  var logs: [String]

  init(email: String, password: String, joinDate: Date, logs: [String]) {
    self.logs = logs

    super.init(email: email, password: password, joinDate: joinDate)
  }
}
#endif

// 상속의 문제점 - 경직된 설계
// - 새로운 Account 타입이 도입될 때, 기존에 설계한 구조와 다를 경우 전체적인 구조에 대한 리팩토링이 필요합니다.
// - 상속을 이용하기 위해서는 참조 타입인 클래스를 이용해야 합니다.

// Guest
//  - email / password가 필요하지 않습니다.
class Account {
  let joinDate: Date

  init(joinDate: Date) {
    self.joinDate = joinDate
  }
}

class User: Account {
  let email: String
  let password: String

  var level: Int
  var exp: Int

  // 자신의 속성을 먼저 초기화하고, 부모의 초기화 메소드를 이용해서 초기화를 수행합니다.
  init(email: String, password: String, joinDate: Date, level: Int, exp: Int) {
    self.email = email
    self.password = password
    self.level = level
    self.exp = exp

    super.init(joinDate: joinDate)
  }
}

class Admin: Account {
  let email: String
  let password: String
  var logs: [String]

  init(email: String, password: String, joinDate: Date, logs: [String]) {
    self.email = email
    self.password = password
    self.logs = logs

    super.init(joinDate: joinDate)
  }
}

class Guest: Account {
  var level: Int
  var exp: Int

  init(joinDate: Date, level: Int, exp: Int) {
    self.level = level
    self.exp = exp

    super.init(joinDate: joinDate)
  }
}

let arr: [Account] = [
  User(email: "chansik@gmail.com", password: "linux123", joinDate: Date(), level: 0, exp: 0),
  Admin(email: "chansik@gmail.com", password: "linux123", joinDate: Date(), logs: []),
  Guest(joinDate: Date(), level: 0, exp: 0)
]
