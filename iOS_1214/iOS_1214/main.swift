

import Foundation

#if false
// 실패가 불가능한 연산
enum MyError: Error {
  // case를 제공하지 않습니다.
}

func load(url: String, completion: (Result<String, MyError>) -> Void) {}

load(url: "https://google.com") { result in
  switch result {
  case let .success(data):
    print(data)
  }
}
#endif

func load(url: String, completion: (Result<String, Never>) -> Void) {}

load(url: "https://google.com") { result in
  switch result {
  case let .success(data):
    print(data)
  }
}
