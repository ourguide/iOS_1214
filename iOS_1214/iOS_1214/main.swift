
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
let cache = CachedValue(timeToLive: 1) { () -> Int in
  print("값이 갱신되었습니다")
  n += 1
  return n
}

print(cache.value)
print(cache.value)
sleep(1)
print(cache.value)
print(cache.value)
sleep(1)
print(cache.value)
print(cache.value)
