
import Foundation

// enum
// : 스위프트의 핵심 도구입니다.

// 채팅 메세지
//  1. 일반적인 텍스트 메시지
//  2. 채팅 참가 메세지
//  3. 채팅 탈퇴 메세지

#if false
struct Message {
  let userId: Int
  let contents: String?
  let date: Date

  let hasJoined: Bool
  let hasLeft: Bool
}

let joinMessage = Message(userId: 1, contents: nil, date: Date(), hasJoined: true, hasLeft: false)
let textMessage = Message(userId: 1, contents: "Hello", date: Date(), hasJoined: false, hasLeft: false)
let leftMessage = Message(userId: 1, contents: nil, date: Date(), hasJoined: false, hasLeft: true)

// 잘못된 상태의 객체가 만들어질 수 있습니다.
let wrongMessage = Message(userId: 1, contents: "Hi", date: Date(), hasJoined: true, hasLeft: true)
#endif

// 해결 방법 - enum
// - '상호 베타적'인 관계를 표현할 수 있습니다.
// - 연관 값(튜플)을 이용하면, 데이터도 포함할 수 있습니다.

enum Message {
  case text(userId: Int, contents: String, date: Date)
  case join(userId: Int, date: Date)
  case leave(userId: Int, date: Date)
  // case etc
}

let joinMessage = Message.join(userId: 1, date: Date())

let textMessage: Message = .text(userId: 1, contents: "Hello", date: Date())
let leftMessage: Message = .leave(userId: 1, date: Date())

func logMessage(message: Message) {
  // 모든 경우를 처리해야 합니다.
  //  switch message {
  //  case .text(userId: let userId, contents: let contents, date: let date):
  //    break
  //  case .join(userId: let userId, date: let date):
  //    break
  //  case .leave(userId: let userId, date: let date):
  //    break
  //  }

  switch message {
  case let .text(userId, contents, date):
    print("[\(date)(\(userId))] \(contents)")
  case let .join(userId, date):
    print("[\(date)(\(userId))] Join")
  case let .leave(userId, date):
    print("[\(date)(\(userId))] Leave")
  }
}

logMessage(message: joinMessage)
logMessage(message: textMessage)
logMessage(message: leftMessage)

// 단일 항목을 처리하고 싶을 때는 if case 를 사용하면 됩니다.
if case let .text(userId, contents, date) = textMessage {
  print("[\(date)(\(userId))] \(contents)")
}


