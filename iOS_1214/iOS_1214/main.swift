
import Foundation

// 비동기 오류 처리
// - Result
//  : 스위프트 5의 비동기 오류 처리에 대한 공식적인 솔루션 입니다.

// 1) 비동기 호출에서 오류가 발생하였을 경우, 오류에 대한 정보를 콜백을 통해 전달해야 합니다.
//  - 별도의 스레드(스택)에서 발생하는 오류는 전달되지 않습니다.
//  - 오류의 인자를 콜백의 마지막 인자로 전달합니다.

let url = "https://api.github.com/users/apple"

#if false
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
#endif

// - 클로저가 끝난 이후에 수행되는 클로저에 대해서는 @escaping 을 지정해야 합니다.
// - 클로저가 Optional 인 경우 기본이 @escaping 입니다.
// func getJSON(with url: URL, completion: ((Data?, Error?) -> Void)?) {

#if false
func getJSON(with url: URL, completion: @escaping (Data?, Error?) -> Void) {
  let task = URLSession.shared.dataTask(with: url) { (data: Data?, _: URLResponse?, error: Error?) in
    completion(data, error)
  }

  task.resume()
}

if let url = URL(string: url) {
  getJSON(with: url) { data, error in
    if let error = error {
      print(error)
    } else if let data = data {
      print(data)
    } else {
      print("????") // 이 상태는 발생하지 않습니다.
      // 해결 방법: 코드로는 상호 베타적인 관계를 표현하기 어렵습니다.
      //          enum 기반의 Result를 이용해서 표현할 수 있습니다.
    }
  }
}
#endif

// Result는 Optional과 유사합니다.
#if false
enum Result<Success, Failure: Error> {
  case success(Success)
  case failure(Failure)
}
#endif

enum NetworkError: Error {
  case fetchFailed(Error)
}

func getJSON(with url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
  let task = URLSession.shared.dataTask(with: url) { (data: Data?, _: URLResponse?, error: Error?) in

    if let dataTaskError = error.map({ NetworkError.fetchFailed($0) }) {
      completion(.failure(dataTaskError))
    } else if let data = data {
      completion(.success(data))
    } else {
      fatalError("Invalid state")
    }
  }

  task.resume()
}

// if let url = URL(string: url) {
//  getJSON(with: url) { result in
//
//    switch result {
//    case let .success(data):
//      print(data)
//    case let .failure(error):
//      print(error)
//    }
//
//  }
// }

let searchUrl = "https://api.github.com/search/users?q="

typealias JSON = [String: Any]

enum SearchResultError: Error {
  case invalidQuery(String)
  case invalidJSON
  case networkError(NetworkError)
}

func searchUsers(q: String, completion: @escaping (Result<JSON, SearchResultError>) -> Void) {
  let encodedQuery = q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

  let path: String? = encodedQuery.map {
    searchUrl + $0
  }

  // 여기서 flatMap을 사용해야 하는 이유를 정확하게 이해해야 합니다.
  // let url = path.flatMap { URL(string: $0) }
  guard let url = path.flatMap(URL.init) else {
    completion(.failure(.invalidQuery(q)))
    return
  }

  getJSON(with: url) { result in

    switch result {
    case let .success(data):
      if let json = try? JSONSerialization.jsonObject(with: data, options: []),
         let jsonDic = json as? JSON
      {
        // JSON 변환 성공
        completion(.success(jsonDic))
      } else {
        // JSON 변환 실패
        completion(.failure(.invalidJSON))
      }

    case let .failure(error):
      completion(.failure(.networkError(error)))
    }
  }
}

sleep(3)
