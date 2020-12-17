
import Foundation

final class CachedValue<Element> {
  private let load: () -> Element
  private var lastLoaded: Date

  private var timeToLive: Double
  private var currentValue: Element

  public var value: Element {
    let isRefresh = abs(lastLoaded.timeIntervalSinceNow) > timeToLive
    if isRefresh {
      currentValue = load()
      lastLoaded = Date()
    }

    return currentValue
  }

  init(timeToLive: Double, load: @escaping () -> Element) {
    self.timeToLive = timeToLive
    self.load = load

    currentValue = load()
    lastLoaded = Date()
  }
}

var n = 0
let cache1 = CachedValue(timeToLive: 1) { () -> Int in
  print("값이 갱신되었습니다")
  n += 1
  return n
}

let cache2 = CachedValue(timeToLive: 1) { () -> Int in
  print("값이 갱신되었습니다")
  n += 1
  return n
}

if cache1 == cache2 {}
if cache1 > cache2 {}

let data: Set<CachedValue> = [
  cache1,
  cache2,
]

extension CachedValue: Equatable where Element: Equatable {
  static func == (lhs: CachedValue<Element>, rhs: CachedValue<Element>) -> Bool {
    return lhs.value == rhs.value
  }
}

extension CachedValue: Comparable where Element: Comparable {
  static func < (lhs: CachedValue<Element>, rhs: CachedValue<Element>) -> Bool {
    return lhs.value < rhs.value
  }
}

extension CachedValue: Hashable where Element: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(value)
  }
}

#if false
print(cache.value)
print(cache.value)
sleep(1)
print(cache.value)
print(cache.value)
sleep(1)
print(cache.value)
print(cache.value)
#endif

// class 타입은 struct와 다르게, Equtable / Hashable 의 구현을 자동으로 생성하지 않습니다.
// - 반드시 별도로 제공해주어야 합니다.
class User: Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    return lhs.name == rhs.name
  }
  
  let name: String

  init(name: String) {
    self.name = name
  }
}
