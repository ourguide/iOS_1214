
import Foundation

// 스위프트에서는 제네릭을 활용해서, 컴파일 타임 다형성을 구현하는 경우가 많습니다.
#if false
func firstAndLast(_ array: [Int]) -> (Int, Int) {
  return (array[0], array[array.count - 1])
}

let arr = [1, 2, 3, 4, 5]
let result = firstAndLast(arr)

print("\(result.0) \(result.1)")

// 문자열 배열에서도 동작하는 버전이 필요하다.
// => 오버로딩
func firstAndLast(_ array: [String]) -> (String, String) {
  return (array[0], array[array.count - 1])
}

let arr2 = ["Apple", "Pineapple", "Orange"]
let result2 = firstAndLast(arr2)

print("\(result2.0) \(result2.1)")
#endif

// Generic - 컴파일 시간에 다양한 타입에 대응하는 '코드를 생성'할 수 있습니다
//   1) 보일러플레이트를 제거할 수 있다.
//   2) 한번만 만들면 되고, 아직 작성하지 않은 사용자 정의 타입에 대해서도 대응이 가능하다.
//   3) Any를 사용하지 않아도 되기 때문에, 실행 시간에 다운 캐스트 같은 동작을 수행할 필요도 없습니다.

func firstAndLast<T>(_ array: [T]) -> (T, T) {
  return (array[0], array[array.count - 1])
}

let arr = [1, 2, 3, 4, 5]
let result = firstAndLast(arr)
print("\(result.0) \(result.1)")

// -----

let arr2 = ["Apple", "Pineapple", "Orange"]
let result2 = firstAndLast(arr2)
print("\(result2.0) \(result2.1)")

struct User {
  let name: String
  let age: Int
}

let arr3 = [
  User(name: "Tom", age: 42), User(name: "Alice", age: 30), User(name: "Bob", age: 17),
]

let result3 = firstAndLast(arr3)
print("\(result3.0) \(result3.1)")
