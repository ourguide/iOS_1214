
import Foundation

// Optional
struct User {
  let id: Int
  let email: String
  let firstName: String? // Optional<String>
  let lastName: String? // Optional<String>
}

#if false
let user = User(id: 0, email: "hello@gmail.com", firstName: "Gildong", lastName: "Hong")

// 1) enum을 통해 Optional이 만들어져 있습니다.
/*
 enum Optional<Wrapped> {
   case none
   case some(Wrapped)
 }
 */

switch user.firstName {
case let .some(value):
  print("Firstname - \(value)")
case .none:
  print("Firstname에 입력이 안되었습니다.")
}

// 위의 표현을 좀더 간결하게 표현할 수 있습니다.
switch user.lastName {
case let value?:
  print("Lastname - \(value)")
case nil:
  print("존재하지 않습니다.")
}

// 동시에 두 개 이상의 Optinal을 처리하는 것도 가능합니다.
if let firstName = user.firstName {
  if let lastName = user.lastName {
    print("\(firstName) \(lastName)")
  }
}

if let firstName = user.firstName,
   let lastName = user.lastName
{
  print("\(firstName) \(lastName)")
}

// 다른 조건과 결합해서 사용하는 것도 가능합니다.
if let firstName = user.firstName, !firstName.isEmpty {
  print("조건 결합: \(firstName)")
}

if let _ = user.firstName,
   let _ = user.lastName
{
  print("이름이 모두 입력되었습니다.")
}

if user.firstName != nil, user.lastName != nil {
  print("이름이 모두 입력되었습니다.")
}

#endif

class Person {
  let email: String
  let name: String

  init(email: String, name: String) {
    self.email = email
    self.name = name
  }
}

let user = User(id: 0, email: "hello@gmail.com", firstName: "Gildong", lastName: "Hong")
let person = Person(email: "hello@gmail.com", name: "Gildong")

print(user)
print(person)

// dump를 이용하면, 내부의 속성 값을 확인하는 데 유용합니다.
// - dump(user)
// - dump(person)

// CustomStringConvitable 의 프로토콜을 만족하면, 사용자가 원하는 형태로 문자열 변환이 가능합니다.
extension User: CustomStringConvertible {
  var description: String {
    var result = "\(email)(\(id)) - "

    if let unwrappedFirstName = firstName {
      result += unwrappedFirstName
    }

    // 스위프트에서 옵셔널 값에 대한 바인딩을 사용할 때, 동일한 이름을 통해 가리는 것이 일반적입니다.
    if let lastName = lastName {
      result += " \(lastName)"
    }

    return result
  }
}

extension Person: CustomStringConvertible {
  var description: String {
    return "\(email) - \(name)"
  }
}
