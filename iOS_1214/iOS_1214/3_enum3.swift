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

// 상속은 다형성을 구현하는 방법입니다.

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

  func display() {
    print("Account display")
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

  override func display() {
    print("User display")
  }
}

class Admin: Account {
  var logs: [String]

  init(email: String, password: String, joinDate: Date, logs: [String]) {
    self.logs = logs

    super.init(email: email, password: password, joinDate: joinDate)
  }

  override func display() {
    print("Admin display")
  }
}
#endif

// 상속의 문제점 - 경직된 설계
// - 새로운 Account 타입이 도입될 때, 기존에 설계한 구조와 다를 경우 전체적인 구조에 대한 리팩토링이 필요합니다.
// - 상속을 이용하기 위해서는 참조 타입인 클래스를 이용해야 합니다.

// Guest
//  - email / password가 필요하지 않습니다.
#if false
class Account {
  let joinDate: Date

  init(joinDate: Date) {
    self.joinDate = joinDate
  }

  func display() {
    print("Account display")
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

  override func display() {
    print("User display")
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

  override func display() {
    print("Admin display")
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

  override func display() {
    print("Guest display")
  }
}

let arr: [Account] = [
  User(email: "chansik@gmail.com", password: "linux123", joinDate: Date(), level: 0, exp: 0),
  Admin(email: "chansik@gmail.com", password: "linux123", joinDate: Date(), logs: []),
  Guest(joinDate: Date(), level: 0, exp: 0),
]

// 다형성은 상속을 통해서 구현 가능합니다.
for e in arr {
  e.display()
}

#endif

// enum을 이용하면, 상속의 관계를 표현할 수 있습니다.

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

struct Guest {
  let joinDate: Date

  var level: Int
  var exp: Int
}

// 문제점
//  1) enum을 사용하면 중복된 항목을 별도로 캡슐화하는 것이 어렵습니다.
//  2) 다형성을 구현하기 어렵습니다.

// 장점
//  1) 새로운 유형을 추가할 때, 기존 코드의 수정이 필요하지 않습니다.
//  2) 구조체를 활용할 수 있습니다.
enum Account {
  case user(User)
  case admin(Admin)
  case guest(Guest)
}

// extension을 통해서 기능을 내부적으로 처리할 수 있습니다.
//  => class의 오버라이딩보다 더 좋은 성능으로 동작한다.
extension Account {
  func display() {
    switch self {
    case let .user(v):
      print(v)
    case let .admin(v):
      print(v)
    case let .guest(v):
      print(v)
    }
  }
}

//----------------------------
let arr: [Account] = [
  .user(User(email: "chansik@gmail.com", password: "linux123", joinDate: Date(), level: 0, exp: 0)),
  .admin(Admin(email: "chansik@gmail.com", password: "linux123", joinDate: Date(), logs: [])),
  .guest(Guest(joinDate: Date(), level: 0, exp: 0)),
]

for e in arr {
  e.display()
}
