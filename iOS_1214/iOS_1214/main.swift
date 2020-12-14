
import Foundation

// 스위프트 오류 처리
// 1. 각 에러는 상호 베타적이기 때문에 enum이 편리합니다.
enum ParseLocationError: Error {
  case invalidData
  case network(String)
  case locationDoesNotExist
}

// 2. 오류에 추가적인 정보가 필요한 경우, 다른 타입도 사용할 수 있습니다.
struct MulpleParseLocationErros: Error {
  let parsingErrors: [ParseLocationError]
  let isShownToUser: Bool
}

struct Location {
  let latitude: Double
  let longitude: Double
}

// 3. 스위프트의 함수(메소드)가 오류를 던질 경우, throws 키워드를 지정해야 합니다.
//  - 어떤 종류의 오류를 던지는지 알 수 없다.
//   해결책: 문서화를 활용해야 한다. => Command + Alt + /

/// 문자열로 되어 있는 위도 경도를 Location 구조체로 만들어줍니다.
/// - Parameters:
///   - latitude: 위도 문자열
///   - longitude: 경도 문자열
/// - Throws: 문자열을 Double로 변경이 불가능할 경우, ParseLocationError.invalidData 오류가 발생합니다.
/// - Returns: Location 구조체
func parseLocation(_ latitude: String, _ longitude: String) throws -> Location {
  guard let latitude = Double(latitude), let longitude = Double(longitude) else {
    throw ParseLocationError.invalidData
  }

  return Location(latitude: latitude, longitude: longitude)
}
