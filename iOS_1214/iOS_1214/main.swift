
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

#if false
// class func
class Car {
  class var name: String {
    return "Car"
  }

  // 타입에 대한 정보를 런타임에 동적으로 접근할 수 있다.
  //  정의: 자기 자신의 동적 클래스
  // - Self
  func show() {
    print(Self.name)
  }
}

class Truck: Car {
  override class var name: String {
    return "Truck"
  }
}

// print(Car.name)
// print(Truck.name)

let car: Car = Truck()
car.show()
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

#if true
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

// class - 상속
class CarMarket {
  let cars: [Car]
  let capacity: Int

  // 4. class 타입은 초기화메소드를 반드시 제공해야 합니다.
  //  - 모든 프로터피를 온전하게 초기화하는 초기화 메소드를 '지정 초기화 메소드'라고 합니다.
  //  - 파라미터 기본값을 제공하면, 불필요한 오버로딩을 방지할 수 있습니다.
  required init(cars: [Car], capacity: Int = 100) {
    self.cars = cars
    self.capacity = capacity
  }

  convenience init(names: [String]) {
    var cars = [Car]()
    for name in names {
      cars.append(Car(name: name))
    }

    // 5. 지정 초기화 메소드로 위임할 수 있습니다. - 편의 초기화 메소드
    // self.cars = cars
    // self.capacity = 100
    self.init(cars: cars, capacity: 100)
  }

  // 정적 팩토리 메소드 - static factory method
  //  - 문제점: 자식 클래스 반드시 팩토리 함수를 재정의해야 합니다.
  // class func create(cars: [Car]) -> CarMarket {
  //   return CarMarket(cars: cars)
  // }

  class func create(cars: [Car]) -> Self {
    return self.init(cars: cars)
    // 정적 팩토리 메소드에서 호출하는 초기화 메소드는 반드시 자식 클래스에서도 정의되어야 한다. - required
  }
}

// let market1 = CarMarket(cars: [], capacity: 100)
// let market2 = CarMarket(cars: [])
// let market3 = CarMarket(names: [
//  "Sonata",
//  "Santafe",
//  "Avante"
// ])

class OnlineCarMarket: CarMarket {
  let url: String

  init(cars: [Car], capacity: Int = 100, url: String) {
    self.url = url

    super.init(cars: cars, capacity: capacity)
  }

  // 8. 부모의 지정 초기화 메소드를 오버라이딩 하면 됩니다.
  // 9. 부모의 지정 초기화 메소드를 자식 클래스의 지정 초기화 메소드를 호출하는 편의 초기화 메소드로 만들면 편리합니다.
  // override convenience init(cars: [Car], capacity: Int = 100) {

  // - required는 override를 포함하기 때문에 생략 가능하다.
  required convenience init(cars: [Car], capacity: Int = 100) {
    // self.url = "https://car.naver.com/"
    // super.init(cars: cars, capacity: capacity)

    self.init(cars: cars, capacity: capacity, url: "https://car.naver.com/")
  }

  // 팩토리 함수를 재정의해야 합니다.
  // override class func create(cars: [Car]) -> OnlineCarMarket {
  //  return OnlineCarMarket(cars: cars)
  // }
}

// 6. 자식 클래스가 초기화 메소드를 제공하지 않을 경우, 부모의 지정 초기화 메소드와 편의 초기화 메소드를 사용할 수 있다.
let market1 = OnlineCarMarket(cars: [], capacity: 100)
let market2 = OnlineCarMarket(cars: [])
let market3 = OnlineCarMarket(names: [
  "Sonata",
  "Santafe",
  "Avante"
])

// 7. 자식이 초기화 메소드를 제공할 경우, 부모의 초기화 메소드(지정, 편의)는 사용할 수 없다,
let market4 = OnlineCarMarket(cars: [], capacity: 100, url: "https://car.naver.com")
#endif

let market5 = OnlineCarMarket.create(cars: [])
let market6 = CarMarket.create(cars: [])

// dump(market5)
// dump(market6)

// required init
//  1) 클래스 팩토리 메소드
//  2) 프로토콜

protocol UserType {
  init(name: String)
}

class User: UserType {
  let name: String

  required init(name: String) {
    self.name = name
  }
}

// final class인 경우, required를 생략할 수 있습니다.
// => 상속 계층의 마지막 클래스
//  : 상속 계층의 마지막 클래스에 대해서 final을 사용하는 것은 프로그램의 성능 향상에 도움이 된다.
//   - https://developer.apple.com/swift/blog/?id=27
final class Guest: UserType {
  let name: String

  init(name: String) {
    self.name = name
  }
}

struct Admin: UserType {
  // 구조체의 경우 required가 필요하지 않습니다.
  init(name: String) {
    
  }
}
