import Foundation

// Conditional Comformance - 조건부 순응

// 내부의 모든 속성이 Equtable을 만족하면, Movie도 자동으로 Equtable을 생성할 수 있다.
struct Movie: Equatable {
  let title: String
  let rating: Float

  func play() {
    print("Movie - \(title)-\(rating)")
  }
}

let movie1 = Movie(title: "타이타닉", rating: 4.9)
let movie2 = Movie(title: "타이타닉", rating: 4.9)

if movie1 == movie2 {
  print("같은 영화입니다.")
}

let movies: [Movie] = [
  movie1,
  movie2,
]
movies.play()

// 해결 방법
protocol Playable {
  func play()
}

extension Movie: Playable {}

// 조건부 순응
extension Array: Playable where Element: Playable {
  func play() {
    for e in self {
      e.play()
    }
  }
}

// -----

func playDelayed<T: Playable>(_ movie: T, delay: Double) {
  movie.play()
}

let movie3: Movie? = movie1
playDelayed(movie3, delay: 3.0)

extension Optional: Playable where Wrapped: Playable {
  func play() {
    switch self {
    case let movie?:
      movie.play()
    case nil:
      break  
    }
  }
}
