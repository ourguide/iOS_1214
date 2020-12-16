

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

// Never: 인스턴스화가 불가능한 타입
//  - 실패 불가능한 Result를 표현할 때 사용됩니다.
func load(url: String, completion: (Result<String, Never>) -> Void) {}

load(url: "https://google.com") { result in
  switch result {
  case let .success(data):
    print(data)
  }
}

//  - 함수의 반환이 불가능한 경우 사용됩니다.
func foo() -> Never {
  fatalError("xxx")
}
