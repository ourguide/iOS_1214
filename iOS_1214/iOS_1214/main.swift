
import Foundation

// 배열의 최소값을 찾는 함수 - Generic
// 1) 일반 타입으로 먼저 작성해보면 좋습니다.

#if false
func lowest(_ array: [Int]) -> Int? {
  // 1) 오름차순 정렬
  let sorted = array.sorted { (lhs, rhs) -> Bool in
    lhs < rhs
  }

  // 2) 오름차순 정렬된 배열의 첫번째 원소 반환
  return sorted.first
}

let arr = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
if let result = lowest(arr) {
  print(result)
}
#endif

// 오류의 원인: T는 모든 타입이 될 수 있기 때문에,
//           T가 비교가 불가능할 수도 있습니다.

// 해결방법: 제네릭 타입 T에 대한 제약사항 정의해야 합니다.
//    비교 - Comparable(protocol)
//    => T가 Comparable을 만족해야 한다.

// 표시 방법 1.
//   <T: Comparable>
#if false
func lowest<T: Comparable>(_ array: [T]) -> T? {
  // 1) 오름차순 정렬
  let sorted = array.sorted { (lhs, rhs) -> Bool in
    lhs < rhs
  }

  // 2) 오름차순 정렬된 배열의 첫번째 원소 반환
  return sorted.first
}
#endif

// 표시 방법 2.
//   where T: Comparable
func lowest<T>(_ array: [T]) -> T? where T: Comparable {
  // 1) 오름차순 정렬
  let sorted = array.sorted { (lhs, rhs) -> Bool in
    lhs < rhs
  }

  // 2) 오름차순 정렬된 배열의 첫번째 원소 반환
  return sorted.first
}

let arr = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
if let result = lowest(arr) {
  print(result)
}

let arr2 = ["hello", "world", "abcd"]
if let result = lowest(arr2) {
  print(result)
}

