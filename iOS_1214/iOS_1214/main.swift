
import Foundation

class Car {
  func go() {
    print("Car go")
  }
}

class Truck: Car {
  override func go() {
    print("Truck go")
  }
}

// 부모 참조 타입은 자식 타입 객체를 참조할 수 있습니다. - 암묵적인 Upcasting 허용합니다.ㄴ
let car: Car = Truck()
car.go()

// - 제네릭이 공변적이다.
// let truck: Optional<Truck> = Truck()
// let car2: Optional<Car> = truck

// let truck: Truck? = Truck()
// let car2: Car? = truck

// -------------------
struct Container<T> {}

// 표준 라이브러리에서 제공하는 제네릭 타입(Optional)은 공변적이지만, - covariant
// 사용자가 제공하는 제네릭은 공변적이지 않습니다. - invariant

// let truck: Container<Truck> = Container<Truck>()
// let car2: Container<Car> = truck
