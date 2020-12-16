
import Foundation

// 함수형 프로그래밍
//    - map
//     : transform 으로도 불리는 언어가 있습니다.

typealias User = (name: String, count: Int)


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

let commitsPerUser: [User] = [
  (name: "Tom", count: 30),
  (name: "Bob", count: 150),
  (name: "Alice", count: 0),
]

let result = resolveCounts(statistics: commitsPerUser)
print(result)


