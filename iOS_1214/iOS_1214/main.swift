
import Foundation

// Extension을 사용할 때 주의할 점

class UIViewController {}

#if false
// 원하지 않는 사용자들도, UIViewController에 track이 추가된다.
// => 함부로 추가되면 안됩니다!
extension UIViewController {
  func track(event: String, parameters: [String: Any]) {
    print("UIViewController 이벤트 추적")
  }
}
#endif

// 스위프트에서는 이 문제를 해결할 수 있습니다.

protocol AnalyticsProtocol {
  func track(event: String, parameters: [String: Any])
}

// 제약을 추가하면 UIViewController 에서만 사용할 수 있습니다.
// => 아래의 기본 구현은 UIViewController가 AnalyticsProtocol을 명시적으로 구현해야만 노출됩니다.
extension AnalyticsProtocol where Self: UIViewController {
  func track(event: String, parameters: [String: Any]) {
    print("AnalyticsProtocol - 이벤트 추적")
  }
}

class MyViewController: UIViewController, AnalyticsProtocol {
  func viewDidLoad() {
    // super.viewDidLoad()

    track(event: "view open", parameters: [:])
  }
}

// -------------------------------------

let arr = [1, 2, 3, 3, 2, 1]
let result = arr.unique()
print(result)

// [[version 2]  version 1 ]

// Version 1
extension Collection where Element: Equatable {
  func unique() -> [Element] {
    print("Equtable 버전을 사용합니다.")
    var uniqueValues = [Element]()

    for element in self {
      if !uniqueValues.contains(element) { // O(N)
        uniqueValues.append(element)
      }
    }

    return uniqueValues
  }
}

// Hashable - Dictionary / Set(집합) - 중복을 허용하지 않습니다. - O(1)
extension Collection where Element: Hashable {
  func unique() -> [Element] {
    print("Hashable 버전을 사용합니다.")

    var uniqueValues = Set<Element>()

    for element in self {
      if !uniqueValues.contains(element) { // O(N)
        uniqueValues.insert(element)
      }
    }

    return [Element](uniqueValues)
  }
}
