
import Foundation

// Tuple - 다양한 값의 묶음
// => 임시적으로 사용할 때는 유용하지만, 범용적으로 사용될 경우 구조체나 클래스를 이용해서 캡슐화해야 한다.

func foo() -> (String, Int) {
  return ("Tom", 42)
}

var (name, age) = foo()
print("\(name) \(age)")

var t = foo()
print("\(t.0) \(t.1)")

//-----

func foo2() -> (name: String, age: Int) {
  return (name: "Tom", age: 42)
}

var (name2, age2) = foo2()
print("\(name2) \(age2)")

var t2 = foo2()
print("\(t2.name) \(t2.age)")
