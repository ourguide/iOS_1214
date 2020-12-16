
import Foundation

let suits = ["Hearts", "Clubs", "Diamonds", "Spades"]
let faces = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

// let suits = ["Hearts", "Clubs"]
// let faces = ["2", "3", "4"]

let deck = suits.flatMap { suit in
  faces.map { face in
    (suit, face)
  }
}

//                                flatten(flatMap)
// Array<Array<E>>   ->      Array<E>
print(type(of: deck))
print(deck)

let arr = [1, 2, 3, 4, 5]

//    map: Array<Array<Int>>
// flatMap: Array<Int>
let result = arr.flatMap { e in
  [e, e + 1, e + 2]
}

print(result)
