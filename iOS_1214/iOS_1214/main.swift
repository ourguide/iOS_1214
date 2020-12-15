
import Foundation

//                Sequence
//                    |
//                Collection
//                    |
//      +-------------+------------------------------------+
//      |                     |                            |
// MutableCollection   RangeReplicationCollection    BidirectionCollection
//                                                         |
//                                                         |
//                                                   RandomAccessCollection

// MutableCollection
//  : 길이를 변경하지 않고 요소의 값을 변경할 수 있는 연산을 제공한다.
//  - Array
//     : sort / partition

var arr = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
arr.sort()

let index = arr.partition { e -> Bool in
  e % 2 == 0
}

// print(arr)
// print(index)

print(arr[..<index]) // left
print(arr[index...]) // right
