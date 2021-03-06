
import Foundation

// 함수형 프로그래밍
//    - map
//     : transform 으로도 불리는 언어가 있습니다.

typealias User = (name: String, count: Int)

#if false
func resolveCounts(statistics: [User]) -> [String] {
  var result = [String]()

  for (name, count) in statistics {
    // var message: String = ""
    let message: String

    switch count {
    case 0:
      message = "\(name): 아무것도 안함"
    case 1 ..< 100:
      message = "\(name): 열심히 안함"
    default:
      message = "\(name): 열심히 했음"
    }

    result.append(message)
  }

  return result
}
#endif

// [ T ]  ->  [ U ]
func resolveCounts(statistics: [User]) -> [String] {
  return statistics.map { name, count in
    switch count {
    case 0:
      return "\(name): 아무것도 안함"
    case 1 ..< 100:
      return "\(name): 열심히 안함"
    default:
      return "\(name): 열심히 했음"
    }
  }
}

// count가 0이 아닌 데이터를 정렬해서 반환한다.
#if false
func counts(statistics: [User]) -> [Int] {
  var counts = [Int]()

  #if false
  for (_, count) in statistics {
    if count > 0 {
      counts.append(count)
    }
  }
  #endif

  // where를 이용해서 위의 코드와 동일 동작을 구현할 수 있습니다.
  for (_, count) in statistics where count > 0 {
    counts.append(count)
  }

  return counts.sorted(by: >)
}
#endif

// 선언적인 코드 - 가독성이 좋다.
//    문제점: 불필요한 루프로 인한 성능 차리가 문제가 된다면,
//           직접 알고리즘을 작성하는 것이 좋을 수 있습니다.
func counts(statistics: [User]) -> [Int] {
  return statistics
    .map { _, count in // [User] -> [Int]     - N
      count
    }
    .filter { e in //                     - N
      e > 0
    }
    .sorted(by: >) //                     - Nlog(N)
}

let commitsPerUser: [User] = [
  (name: "Tom", count: 30),
  (name: "Bob", count: 150),
  (name: "Alice", count: 0),
]

// let result = resolveCounts(statistics: commitsPerUser)
// print(result)

let result = counts(statistics: commitsPerUser)
// print(result)

let dic = Dictionary(commitsPerUser) { name, _ in
  name // Key
}.map { (name, count) -> String in // [String, Int] -> [String]
  switch count {
  case 0:
    return "\(name): 아무것도 안함"
  case 1 ..< 100:
    return "\(name): 열심히 안함"
  default:
    return "\(name): 열심히 했음"
  }
}

// print(dic)
func removeEmojis(_ string: String) -> String {
  var scalars = string.unicodeScalars
  scalars.removeAll {
    $0.properties.isEmoji
  }

  return String(scalars)
}

// Emoji: Command + Ctrl + Space

// Optional 안에 있는 값을 변환하는 작업이 번거롭다.
// var message: String? = "Hello,🧐 world show 🧐me 🧐the money🧐"
var message: String? = "Hello,🧐 world show 🧐me 🧐the money🧐"
if let str = message {
  message = removeEmojis(str)
}

// Optional 안의 값이 존재할 경우, 변환하는 연산을 제공합니다 - map
message = message.map {
  removeEmojis($0)
}

// print(message)

struct Cover {
  let title: String?

  init(title: String?) {
    self.title = title.map {
      // removeEmojis($0)
      $0.trimmingCharacters(in: .whitespaces)
    }
  }

  #if false
  init(title: String?) {
    var temp: String?
    if let title = title {
      temp = removeEmojis(title)
    }

    self.title = temp
  }
  #endif
}
