
import Foundation

// Protocol
//  - 상속(Inheritance) / 합성(Composition)

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

// ----------

// MailValidator를 만족하는 타입이 Mailer의 프로토콜도 만족하고 있다면...
extension MailValidator where Self: Mailer {
  func send2(email: Email) throws {
    try validate(email: email)

    try send(email: email)
  }
}

struct SMTPClient: Mailer, MailValidator {}

let client = SMTPClient()
try client.send2(email: Email(subject: "Hello",
                              body: "Hello world",
                              to: [MailAddress(value: "hello@gmail.com")],
                              from: MailAddress(value: "test@gmail.com")))

extension MailValidator where Self: Mailer {
  func send(email: Email, at: Date) throws {
    try validate(email: email)

    try send(email: email)
  }
}

func submitEmail<T>(sender: T, email: Email) where T: Mailer, T: MailValidator {
  try! sender.send(email: email, at: Date())
}

// 상속
#if false
protocol ValidatingMailer: Mailer {
  func validate(email: Email) throws
}

extension ValidatingMailer {
  func send(email: Email) throws {
    try validate(email: email)

    print("ValidatingMailer: mail sent!")
  }

  func validate(email: Email) throws {
    print("ValidatingMailer: mail is valid!")
  }
}

struct SMTPClient: ValidatingMailer {}

let client = SMTPClient()
try client.send(email: Email(subject: "Hello",
                             body: "Hello world",
                             to: [MailAddress(value: "hello@gmail.com")],
                             from: MailAddress(value: "test@gmail.com")))
#endif
