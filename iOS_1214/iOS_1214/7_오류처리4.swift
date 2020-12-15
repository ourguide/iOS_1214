
import Foundation

// "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

enum UserError: Error {
  case noEmptyValueNotAllowed
  case invalidEmail
}


struct User {
  let email: String

  // 타입 자체를 생성할 때 유효성을 체크하면, 이후의 오류 처리를 줄일 수 있다.
  // - 실패의 원인이 여러개인 경우, 오류를 던지는 것이 좋습니다.
  #if false
  init(email: String) throws {
    guard !email.isEmpty else {
      throw UserError.noEmptyValueNotAllowed
    }

    let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    if email.range(of: pattern, options: .regularExpression, range: nil, locale: nil) == nil {
      throw UserError.invalidEmail
    }

    self.email = email
  }
  #endif
  
  // - 실패의 원인이 1개 이면, Optional을 반환하는 것이 좋습니다.
  init?(email: String) {
    let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    if email.range(of: pattern, options: .regularExpression, range: nil, locale: nil) == nil {
      return nil
    }

    self.email = email
  }
}

if let user = User(email: "@gmail.com") {
  print(user)
}




#if false
// try
//  : 예외를 catch 하거나 다시 외부로 전파할 수 있다.
do {
  let user: User = try User(email: "hello@gmail.com")
  print(user)
} catch {
  print(error)
}

// try!
//  : 예외가 발생하였 을 경우, 프로그램이 종료된다.
//  - 주의해서 사용해야 합니다.
let user1: User = try! User(email: "hello@gmail.com")
print(user1)

// try? - 오류가 발생하였을 경우, nil을 반환한다.
//     => 반환 타입이 Optional이 된다.
if let user2 = try? User(email: "hello@gmail.com") {
  print(user2)
}
#endif
