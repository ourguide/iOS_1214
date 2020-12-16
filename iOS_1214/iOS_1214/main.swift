import Foundation

enum NetworkError: Error {
  case fetchFailed(Error)
}

func getJSON(with url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
  let task = URLSession.shared.dataTask(with: url) { (data: Data?, _: URLResponse?, error: Error?) in

//    if let dataTaskError = error.map({ NetworkError.fetchFailed($0) }) {
//      completion(.failure(dataTaskError))
//    } else if let data = data {
//      completion(.success(data))
//    } else {
//      fatalError("Invalid state")
//    }

    //        map
    // Error?  ->   NetworkError?
    let dataTaskError: NetworkError? = error.map { NetworkError.fetchFailed($0) }
    let result = Result(value: data, error: dataTaskError)

    completion(result)
  }

  task.resume()
}

extension Result {
  init(value: Success?, error: Failure?) {
    if let error = error {
      self = .failure(error)
    } else if let value = value {
      self = .success(value)
    } else {
      fatalError("Invalid state")
    }
  }
}

//     decoding(Decodable)            Encodable
// JSON    ->                    User      ->    JSON
//  - Swift 4에서는 JSON에 직렬화 / 역직렬화 기능이 추가되었습니다.

// Codable: Decodable & Encodable
struct User: Decodable {
  let login: String
  let id: Int
  let avatarUrl: String
  let name: String
  let location: String
  let email: String?

  #if false
  enum CodingKeys: String, CodingKey {
    case login
    case id
    case name
    case location
    case email
    case avatarUrl = "avatar_url"
  }
  #endif
}

// Optional이 필요한 타입에 대해서 정확하게 파악이 필요합니다.

// https://api.github.com/users/$login
/*
 {
   "login": "apple",
   "id": 10639145,
   "avatar_url": "https://avatars0.githubusercontent.com/u/10639145?v=4",
   "name": "Apple",
   "location": "Cupertino, CA",
   "email": null,
 }
 */

// User.self
//  - 자바의 'User.class' 를 전달하는 것과 동일한 개념입니다.

#if false
func getUser(login: String, completion: @escaping (Result<User, Error>) -> Void) {
  let url = URL(string: "https://api.github.com/users/\(login)")!

  getJSON(with: url) { (result: Result<Data, NetworkError>) in

    switch result {
    case let .success(data):
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase

      do {
        let user = try decoder.decode(User.self, from: data)
        completion(.success(user))
      } catch {
        completion(.failure(error))
      }

    case let .failure(error):
      completion(.failure(error))
    }
  }
}
#endif

func getUser(login: String, completion: @escaping (Result<User, Error>) -> Void) {
  let url = URL(string: "https://api.github.com/users/\(login)")!

  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase

  getJSON(with: url) { (result: Result<Data, NetworkError>) in

    // .mapError
    //     NetworkError ->  Error

    // .flatMap(Success 타입의 변환입니다)
    //     data: Data   ->  Result<User, Error>
//    let newResult = result
//      .mapError { (error: NetworkError) -> Error in
//        error
//      }
//      .flatMap { (data: Data) -> Result<User, Error> in
//        Result(catching: {
//          try decoder.decode(User.self, from: data)
//        })
//      }
    
    let newResult = result
      .map { data -> User in
        try! decoder.decode(User.self, from: data)
      }
      .mapError { error -> Error in
        error
      }
    

    completion(newResult)
  }
}

getUser(login: "apple") { result in
  switch result {
  case let .success(user):
    print(user)

  case let .failure(error):
    print(error)
  }
}

sleep(3)

//               map
// Optional<T>    ->     Optional<U>

// T: String
// U: Optional<URL>

//                 map
//   Optional<String> -> Optional<Optional<URL>>

//                flatMap
//   Optional<String> -> Optional<URL>

//   Result<Success, Failure>

//                    map
//   SuccessT: Data     ->      SuccessU: User
//   FailureT: Error    ->      FailureT: Error

//   Result<Data, Error> ->   Result<User, Error>

//                   mapError
//   SuccessT: User            ->      SuccessT: User
//   FailureT: NetworkError    ->      FailureU: Error

//                   map
//   SuccessT: Data        ->    SuccessU: Result<User, Error>

//   Result<Data, Error>   ->    Result<Result<User, Error>, Error>

//                  flatMap
//   SuccessT: Data        ->    SuccessU: Result<User, Error>

//                 flatMapError(실패의 이유중에 성공으로 취급하고 싶다.)
//  FailureT: Error       ->   FailureU: Result<User, Error>
