
// https://medium.com/ios-os-x-development/swift-protocol-extension-method-dispatch-6a6bf270ba94

import Foundation

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

