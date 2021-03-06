
import Foundation

// interface
protocol Shape {
  // func draw()
}

// 아래 코드 때문에 정적 바인딩이 아닙니다.
//  - 약속된 draw 메소드에 대한 기본 구현을 제공합니다.
extension Shape {
  func draw() {
    print("Shape draw")
  }
}

struct Rect: Shape {
  func draw() {
    print("Rect draw")
  }
}

struct Circle: Shape {
  func draw() {
    print("Circle draw")
  }
}

let shapes: [Shape] = [
  Rect(),
  Circle()
]

for shape in shapes {
  shape.draw()
}

// ----------
protocol Plant {
  // func grow()
}

extension Plant {
  func grow() {
    print("Plant - grow()")
  }
}

protocol Tree: Plant {}

extension Tree {
  func grow() {
    print("Tree - grow()")
  }
}

struct Oak: Tree {
  // Shadowing
  func grow() {
    print("Oak - grow()")
  }
}

struct CherryTree: Tree {}
struct KiwiPlant: Plant {}

// func grow<P: Plant>(_ plant: P) {
//  plant.grow()
// }

Oak().grow()
CherryTree().grow()
KiwiPlant().grow()

// 프로토콜과 기본 구현을 통한 바인딩
#if false
protocol Base {
  func foo()
}

struct Derived: Base {
  func foo() {
    print("Derived foo")
  }
}

let d: Base = Derived()  // Derived foo
d.foo()
#endif

#if false
// 프로토콜이 기본 구현을 제공하는 경우 - 동적 디스패치
protocol Base {
  func foo()
}

extension Base {
  func foo() {
    print("Base foo")
  }
}

struct Derived: Base {
  func foo() {
    print("Derived foo")
  }
}

let d: Base = Derived() // Derived foo - Derived가 foo를 제공하는 경우
                        // Base foo    - Derived가 foo를 제공하지 않은 경우, 프로토콜의 기본 구현을 사용할 수 있다.
d.foo()
#endif

protocol Base {
  // 선언이 제공되지 않는다. - 무조건 Base foo를 호출한다.(정적 디스패치)
  // foo에 대한 메소드 요구사항이 존재하지 않는다.
}

extension Base {
  func foo() {
    print("Base foo")
  }
}

struct Derived: Base {
  func foo() {
    print("Derived foo")
  }
}

let d: Base = Derived()
d.foo()

let d2: Derived = Derived()
d2.foo()

