
import Foundation

enum LogError: Error {
  case invalidValue
}

#if false
struct Log {
  var values = [String]()

  mutating func append(messages: [String]) throws {
    for message in messages {
      let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)

      if trimmed.isEmpty {
        throw LogError.invalidValue
      } else {
        values.append(trimmed)
      }
    }
  }
}
#endif

struct Log {
  var values = [String]()

  // 2. 연산이 완료된 이후에 객체의 상태를 변경해야 한다.
  //   - 복사본을 이용해서 연산을 수행하는 것이 좋다.
  mutating func append(messages: [String]) throws {
    var temp = values
    
    for message in messages {
      let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)

      if trimmed.isEmpty {
        throw LogError.invalidValue
      } else {
        temp.append(trimmed)
      }
    }
    
    values = temp
  }
}



// 1. 오류가 발생하였을 때, 객체의 상태는 오류 발생 이전과 동일해야 한다.
var log = Log()

do {
  try log.append(messages: [
    "hello, world",
    "               ",
    "show me the money"
  ])
} catch {
  print(error)
}

print(log)
