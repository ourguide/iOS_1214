import Foundation

// Swift Pattern
// - Dependency Injection

struct User: Codable {
  let login: String
  let id: Int
  let avatarUrl: String
  let name: String
  let location: String
  let email: String?
}

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
