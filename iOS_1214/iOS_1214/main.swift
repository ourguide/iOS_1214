
import Foundation

// static vs class
// - class 프로퍼티 / 메소드는 class에서만 만들 수 있습니다.
// - class 오버라이딩이 가능합니다.

#if false
class Car {
  class func foo() {
    print("Car foo")
  }

//  static func foo() {
//    print("Car foo")
//  }
}

class Truck: Car {
  override class func foo() {
    print("Truck foo")
  }

//  static func foo() {
//    print("Truck foo")
//  }
}

Truck.foo()
#endif

// ----------------
// enum이 제공하는 모든 형태를 배열로 얻어올 수 있는 프로토콜이 있습니다.
enum Color: CaseIterable {
  case red, blue, white, crayon
}

#if false
struct Car {
  let name: String
  let color: Color

  init(name: String) {
    self.name = name
    self.color = Color.allCases.randomElement()!
    // randomElement - case가 존재하지 않을 경우, nil을 반환합니다.
  }
}
#endif

struct Car {
  let name: String
  let color: Color
}

// 1. 구조체는 자동으로 각 프로퍼티를 초기화하는 메소드를 제공합니다.
let car = Car(name: "Sonata", color: .white)

// 2. 사용자 정의 초기화 메소드를 제공할 경우, 멤버 와이즈 초기화 메소드는 더 이상 자동으로 제공되지 않습니다.
let car2 = Car(name: "Sonata")
print(car2)

// 3. 사용자 정의 초기화 메소드도 필요하고, 멤버 와이즈 초기화 메소드도 필요한 경우
// => 사용자 정의 초기화 메소드를 extension을 통해 제공하면 됩니다.
extension Car {
  init(name: String) {
    self.name = name
    self.color = Color.allCases.randomElement()!
  }
}
