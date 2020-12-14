
import Foundation

#if false
enum Membership {
  case gold
  case silver
  // case bronze
}

struct User {
  let membership: Membership?
}

let user = User(membership: .gold)

if let membership = user.membership {
  switch membership {
  case .gold:
    print("10% 할인")
  case .silver:
    print("5% 할인")
  }
} else {
  print("0% 할인")
}

// 위의 코드를 간결하게 표현하는 방법
//  주의사항: default를 사용하면, 컴파일러가 새로운 항목이 추가되어도 오류를 주지 않습니다.
switch user.membership {
case .gold?:
  print("10% 할인")
case .silver?:
  print("5% 할인")
case nil:
  print("0% 할인")
}
#endif

// Optional<Bool>
//  - Dictionary
#if false
let preference: [String: Bool] = [
  "autoLogin": true,
  // "faceIdEnabled": true,
]

// - 'nil 병합 연산자'를 이용해서 값이 없을 경우에 대한 기본값을 지정하면 됩니다.
#if false
if let isFaceIdEnabled = preference["faceIdEnabled"] {
  print(isFaceIdEnabled)
}
#endif

if preference["faceIdEnabled"] ?? false {
  print("페이스 아이디 설정 화면")
} else {
  print("활성화되어 있지 않습니다.")
}
#endif

// enum을 활용하면, 위의 세가지 상태를 안전하게 다룰 수 있는 방법을 제공할 수 있습니다.

// RawRepresentable
enum UserPreference: RawRepresentable {
  case enabled
  case disabled
  case notSet

  // init? - X
  init(rawValue: Bool?) {
    switch rawValue {
    case true?:
      self = .enabled
    case false?:
      self = .disabled
    default:
      self = .notSet
    }
  }

  var rawValue: Bool? {
    switch self {
    case .enabled:
      return true
    case .disabled:
      return false
    case .notSet:
      return nil
    }
  }
}

let preference: [String: Bool] = [
  "autoLogin": true,
  "faceIdEnabled": false,
]

let faceIdPref = UserPreference(rawValue: preference["faceIdEnabled"])
switch faceIdPref {
case .enabled:
  print("Enabled")
case .disabled:
  print("Disabled")
case .notSet:
  print("Not set")
}

// Implicitly unwrapping Optional

// Optional
//   - Int? : Explicitly unwrapping Optional
//   - Int! : Implicitly unwrapping Optional

class Database {
  var isConnected = false
}

// 초기화가 보장되는 작업에 대해서만 사용하는 것이 안전합니다.
class UserManager {
  var database: Database!

  class func start() -> UserManager {
    return UserManager()
  }

  func status() -> String {
    if database.isConnected { // Optional인데 암묵적으로 값에 접근이 가능하다.
      return "OK"
    } else {
      return "Database is Down"
    }
  }
}

let manager = UserManager.start()
// manager.database = Database()

let status = manager.status()
print(status)

if let database = manager.database {
  print(database)
}
