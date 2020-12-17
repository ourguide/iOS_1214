
import Foundation

#if true
struct MailAddress {
  let value: String
}

struct Email {
  let subject: String
  let body: String
  let to: [MailAddress]
  let from: MailAddress
}

protocol Mailer {
  func send(email: Email) throws
}

extension Mailer {
  func send(email: Email) {
    print("Mailer: mail sent - \(email)")
  }
}

protocol MailValidator {
  func validate(email: Email) throws
}

extension MailValidator {
  func validate(email: Email) throws {
    print("MailValidator - \(email) is valid!!")
  }
}

// ---------- 프로토콜 합성을 사용하는 방법

// MailValidator를 만족하는 타입이 Mailer의 프로토콜도 만족하고 있다면...
struct Dummy: Mailer {}
extension MailValidator where Self: Mailer {
  func send(email: Email) throws {
    try validate(email: email)

    Dummy().send(email: email)
  }

  // 다른 이름을 사용해서, 기본 구현을 이용한다.
  func sendWithValidate(email: Email) throws {
    try validate(email: email)

    try send(email: email)
  }
}

struct SMTPClient: Mailer, MailValidator {}

let client = SMTPClient()
try client.send(email: Email(subject: "Hello",
                                         body: "Hello world",
                                         to: [MailAddress(value: "hello@gmail.com")],
                                         from: MailAddress(value: "test@gmail.com")))

#endif

#if false
// class version
class Base {
  func foo() {
    print("Base foo")
  }
}

class Derived: Base {
  override func foo() {
    super.foo() // 부모가 제공하는 기본 구현을 사용한다.
    print("Derived foo")
  }
}

let b: Base = Derived()
b.foo()

#endif

// protocol version - 정적 바인딩
//  - (self as Base).foo()

#if false
protocol Base {
  // foo를 제공하지 않습니다.
}

extension Base {
  func foo() {
    print("Base foo")
  }
}

class Derived: Base {
  func foo() {
    (self as Base).foo()

    print("Derived foo")
  }
}

let b = Derived()
b.foo()
#endif

#if false
// https://forums.swift.org/t/calling-default-implementation-of-protocols/328
// 해결 방법
// 1) 다른 이름을 사용해라.
//    - 프로토콜의 기본 구현을 덮어쓰면, 다시 호출할 수 있는 방법을 현재의 스위프트는 제공하지 않습니다.
//    - 기본 구현과 다른 이름의 메소드를 정의해야 합니다.
// 2) Base의 프로토콜을 따르는 더미 구조체를 이용해서, 프로토콜의 기본 구현을 수행한다.
//    - https://bugs.swift.org/browse/SR-117

protocol Base {
  func foo()
}

extension Base {
  func foo() {
    print("Base foo")
  }
}

class Derived: Base {
  func foo() {
    print("Derived foo")

    struct DefaultBase: Base {}
    DefaultBase().foo()
  }

//  func callFoo() {
//    print("Derived foo")
//    foo()
//  }
}

let b = Derived()
b.foo()
// b.callFoo()
#endif
