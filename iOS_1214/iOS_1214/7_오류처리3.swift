
import Foundation

enum ParseLocationError: Error {
  case invalidData
  case network(String)
  case locationDoesNotExist
}

struct Location {
  let latitude: Double
  let longitude: Double
}

func parseLocation(_ latitude: String, _ longitude: String) throws -> Location {
  guard let latitude = Double(latitude), let longitude = Double(longitude) else {
    // throw ParseLocationError.invalidData
    throw ParseLocationError.network("인터넷 연결이 필요합니다.")
  }

  return Location(latitude: latitude, longitude: longitude)
}

#if true
do {
  let location = try parseLocation("3.14x", "4.8")
  print(location)
} catch let error as NSError {
  print(error)
  // ErrorHandler.default.handleError(error)
}
#endif

// 오류에 추가적인 정보를 제공할 수 있습니다.
extension ParseLocationError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .invalidData:
      return "잘못된 데이터 형식입니다."
    case let .network(message):
      return "네트워크 오류 입니다. - \(message)"
    case .locationDoesNotExist:
      return "존재하지 않는 위치 입니다."
    }
  }

  var failureReason: String? {
    switch self {
    case .invalidData:
      return "실패 이유: 잘못된 데이터 형식입니다."
    case let .network(message):
      return "실패 이유: 네트워크 오류 입니다. - \(message)"
    case .locationDoesNotExist:
      return "실패 이유: 존재하지 않는 위치 입니다."
    }
  }

  var recoverySuggestion: String? {
    return "재부팅하세요."
  }
}

// NSError가 출력되는 형식을 지정할 수 있습니다.
extension ParseLocationError: CustomNSError {
  static var errorDomain: String {
    return "ParseLocationError"
  }

  var errorCode: Int {
    switch self {
    case .invalidData:
      return 10
    case .network:
      return 11
    case .locationDoesNotExist:
      return 12
    }
  }

  var errorUserInfo: [String: Any] {
    return [
      NSLocalizedDescriptionKey: errorDescription ?? "",
      NSLocalizedFailureReasonErrorKey: failureReason ?? "",
      NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? "",
      "Hello": 42,
    ]
  }
}

// 오류 처리를 중앙 집중적으로 관리하면, 오류 처리의 중복된 코드를 한 곳에 모아서 관리할 수 있습니다.
struct ErrorHandler {
  // 키워드를 변수명으로 사용하기 위해서는 `default`를 이용하면 됩니다.
  static let `default` = ErrorHandler()

  func handleError(_ error: Error) {
    print("****")
    present("message: \(error)")
  }

  func handleError(_ error: LocalizedError) {
    print("----")
    present("message: \(error.localizedDescription)")
  }

  func present(_ message: String) {
    print(message)
  }
}

#if false
do {
  let location = try parseLocation("3.14x", "4.8")
  print(location)
} catch let error as LocalizedError {
  ErrorHandler.default.handleError(error)
}
#endif
