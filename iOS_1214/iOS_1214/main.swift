
import Foundation

// 비동기 오류 처리
// - Result
//  : 스위프트 5의 비동기 오류 처리에 대한 공식적인 솔루션 입니다.

// 1) 비동기 호출에서 오류가 발생하였을 경우, 오류에 대한 정보를 콜백을 통해 전달해야 합니다.
//  - 별도의 스레드(스택)에서 발생하는 오류는 전달되지 않습니다.
//  - 오류의 인자를 콜백의 마지막 인자로 전달합니다.

let url = "https://api.github.com/users/apple"

func getJSON(with url: URL) {
  let task = URLSession.shared.dataTask(with: url) { (data: Data?, _: URLResponse?, error: Error?) in
    if let error = error {
      print("실패 - \(error)")
      return
    } else if let data = data {
      if let value = String(data: data, encoding: .utf8) {
        print(value)
      }
    }
  }
  task.resume()
}

if let url = URL(string: url) {
  getJSON(with: url)
}

sleep(3)
