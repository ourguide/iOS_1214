import Foundation

// Swift Pattern
// - Dependency Injection: 테스트 용이성

struct User: Codable {
  let login: String
  let id: Int
  let avatarUrl: String
  let name: String
  let location: String
  let email: String?
}

#if false
final class GithubAPI {
  let session: URLSession

  init(session: URLSession) {
    self.session = session
  }

  func getJSON(complection: @escaping (Result<Data, Error>) -> Void) {
    let url = URL(string: "https://api.github.com/users/apple")!

    let task = session.dataTask(with: url) { data, _, error in
      if let error = error {
        complection(.failure(error))
      } else if let data = data {
        complection(.success(data))
      }
    }

    task.resume()
  }
}

let api = GithubAPI(session: URLSession.shared)
api.getJSON { result in
  switch result {
  case let .success(data):
    print("Data - \(data)")

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    if let user = try? decoder.decode(User.self, from: data) {
      print(user)
    }

  case let .failure(error):
    print("Error - \(error)")
  }
}

sleep(1)
#endif

protocol Session {
  associatedtype Task: DataTask

  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Task
}

protocol DataTask {
  func resume()
}

extension URLSession: Session {}
extension URLSessionDataTask: DataTask {}

final class GithubAPI<S: Session> {
  let session: S

  typealias Task = URLSessionDataTask

  init(session: S) {
    self.session = session
  }

  func getJSON(complection: @escaping (Result<Data, Error>) -> Void) {
    let url = URL(string: "https://api.github.com/users/apple")!

    let task = session.dataTask(with: url) { data, _, error in
      if let error = error {
        complection(.failure(error))
      } else if let data = data {
        complection(.success(data))
      }
    }

    task.resume()
  }
}

#if false
let api = GithubAPI(session: URLSession.shared)
api.getJSON { result in
  switch result {
  case let .success(data):
    print("Data - \(data)")

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    if let user = try? decoder.decode(User.self, from: data) {
      print(user)
    }

  case let .failure(error):
    print("Error - \(error)")
  }
}

sleep(1)
#endif

struct TestTask: DataTask {
  func resume() {}
}

struct TestSession: Session {
  typealias Task = TestTask

  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> TestTask {
    return TestTask()
  }
}

let api = GithubAPI(session: TestSession())
api.getJSON { result in
  switch result {
  case let .success(data):
    print("Data - \(data)")

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    if let user = try? decoder.decode(User.self, from: data) {
      print(user)
    }

  case let .failure(error):
    print("Error - \(error)")
  }
}
