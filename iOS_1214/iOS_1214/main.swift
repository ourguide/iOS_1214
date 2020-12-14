
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



