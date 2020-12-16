
import Foundation

#if false
let suits = ["Hearts", "Clubs", "Diamonds", "Spades"]
let faces = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

// let suits = ["Hearts", "Clubs"]
// let faces = ["2", "3", "4"]

let deck = suits.flatMap { suit in
  faces.map { face in
    (suit, face)
  }
}

//               flatten(flatMap)
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
#endif

// Optional - map / flatMap

let info = [
  "url": "https://sample.com/datas",
]

let path: String? = info["url"]

// map: Optional<Optional<String>>
// flatMap: Optional<String>

#if false
let url = path.map { e -> URL in
  URL(string: e)!
}
#endif
let url = path.flatMap { e -> URL? in
  URL(string: e)
}

// print(url)

let strings = [
  "https://naver.com",
  "https://google.com",
  "",
  "https://facebook.com",
]

// let urls: [URL?] = strings.map {
//  URL(string: $0) // URL?
// }

// nil이 발생하는 것은 제거하고 결과도 Optional이 아닙니다.. - compactMap
let urls = strings.compactMap {
  URL(string: $0) // URL?
}

print(urls)

#if false
print("-------------")
// 방법 1.
for url in urls {
  guard let url = url else {
    continue
  }

  print(url)
}

print("-------------")

// 방법 2.
for case let .some(url) in urls {
  print(url)
}

print("-------------")

// 방법 3. - OK!
for case let url? in urls {
  print(url)
}
#endif

// map:        [ T ] ->  [  U  ]
// flatMap:     [ T ] ->  [ [U] ]  -> [ U ]
// compactMap: [ T ] ->  [ U?  ]  -> [ U ]
