
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

do {
  let location = try parseLocation("3.14x", "4.8")
  print(location)
} catch let error as NSError {
  print(error)
}

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
