
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


func writeToFiles(data: [URL: String]) throws {
  var completed = [URL]();
  
  // completed의 개수와 data의 개수가 동일하지 않은 경우, 기존에 처리된 모든 파일을 삭제합니다.
  defer {
    if completed.count != data.count {
      
      // 오류를 복구하는 중에 오류가 발생하면, 복구할 수 없다.
      //  try!: 오류가 발생하였을 경우, 프로그램이 비정상 종료합니다.
      for url in completed {
        try! FileManager.default.removeItem(at: url)
      }
    }
  }
  
  for (url, contents) in data {
    try contents.write(to: url, atomically: true, encoding: .utf8)
    completed.append(url)
  }
}

// 정리
// - 함수에 오류가 발생하였을 때, 이전의 상태로 복원하는 방법
// 1) 임시 변수를 이용해서, 연산이 완료된 후에 객체의 상태를 변경한다.
// 2) defer를 이용해서, 오류 발생 이전 상태로 복원한다.
// 3) 불변 객체로 설계하면, 문제가 발생하지 않습니다.
