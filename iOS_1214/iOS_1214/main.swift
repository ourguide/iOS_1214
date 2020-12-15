
import Foundation

// Sequence 프로토콜을 구현하는 컬렉션은 다양한 기능을 사용할 수 있습니다.
//  - map
//  - filter
//  - sorted
//  - filtered
//  - shuffled

//  - lazy: 대규모 데이터를 처리할 때 유용합니다.
//    1) 중첩된 클로저의 연산이 저장된다.
//    2) 순회를 수행할 때 마다 새롭게 결과가 처리된다.
#if false
let arr = 0 ..< Int.max

print("연산 시작")
let result = arr
  .filter { e -> Bool in
    e.isMultiple(of: 22)
  }.suffix(3)
print("연산 종료")

print(result)
#endif

let arr = 0 ..< Int.max

let result = arr
  .lazy
  .filter { e -> Bool in
    e.isMultiple(of: 22)
  }.suffix(3)

for e in result {
  print(e)
}
