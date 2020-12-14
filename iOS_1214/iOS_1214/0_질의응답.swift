

import Foundation

//          - class  : Reference Type
// mutating - struct : Value Type

class A {
  var value: Int

  init(value: Int) {
    self.value = value
  }
}

var a1 = A(value: 10)
let a2 = A(value: 20)

// -----------
//  Stack                   Heap
//
//  [ a1 ] ----------->    [ 10 ]
//  [ a2 ] ----------->    [ 20 ]
// let / var

struct B {
  var value: Int

  // 모든 메소드는 불변 메소드 - let/var을 통해 호출 가능하다.
  func display() {
    print(value)
  }

  // mutating: var를 통해서만 호출 가능한 메소드
  mutating func inc() {
    value += 1
  }
}

let b1 = B(value: 10) // 변경 불가능한 객체
var b2 = B(value: 20) // 변경 가능한 객체

// b1.inc()
b2.inc()

b1.display()
b2.display()

// b1.value = 30

// -----------
//  Stack
//
//  b1 [ 30 ]
//  b2 [ 20 ]
//  let / var
// https://github.com/ourguide/iOS_1214.git
