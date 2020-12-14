// 프로퍼티
// 1. Stored Property
//   : 데이터를 저장할 수 있는 프로퍼티

// 2. Computed Property
//   : 프로퍼티를 가장한 메소드 입니다.
//     간단한 메소드를 계산형 프로퍼티로 변경함으로써, 코드의 가독성을 올릴 수 있습니다.
import Foundation

struct Timer {
  let id: Int
  let startTime: Date
  var endTime: Date?

  func elapsedTime() -> TimeInterval {
    return Date().timeIntervalSince(startTime)
  }

  func isFinished() -> Bool {
    return endTime != nil
  }

  // 내부의 속성을 변경하는 메소드의 앞에는 mutating을 지정해 주어야 합니다.
  mutating func setFinished() {
    endTime = Date()
  }

  // 사용자가 원하는 형태로 초기화하기 위해서는, 별도의 초기화 메소드를 제공해 주어야 합니다.
  // => 구조체가 자동으로 제공하는 초기화 메소드는 사라집니다.
  init(id: Int, startTime: Date) {
    self.id = id
    self.startTime = startTime
  }
}

// 구조체의 mutating 메소드를 호출하기 위해서는 var를 사용해야 합니다.
var timer = Timer(id: 10, startTime: Date())
print(timer.elapsedTime())
sleep(3)
print(timer.elapsedTime())
timer.setFinished()
print(timer.isFinished())
