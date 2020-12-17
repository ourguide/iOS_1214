
import Foundation

#if false
// Hashble 프로토콜을 만족하면, 사전의 키 타입으로 사용 가능하다.
protocol Game: Hashable {
  func start()
}

struct VideoGame: Game {
  func start() {
    print("Video game - start")
  }
}

struct PCGame: Game {
  func start() {
    print("PC game - start")
  }
}

// 아래 코드는 스위프트에서 제대로 컴파일 되지 않습니다.
// - Protocol 'Game' can only be used as a generic constraint because it has Self or associated type requirements
//  => Equtable 프로토콜 안에는 Self에 대한 요구사항이 존재하기 때문에, 런타임 프로토콜 사용이 불가능합니다.
#if false
var numberOfPlayers: [Game: Int] = [
  VideoGame(): 40,
  PCGame(): 100,
]
#endif
#endif

// 해결 방법
// 1. enum을 사용하자.
//   문제점
//     1) 경우의 수가 많을 경우, 유지보수에 어려움이 생길 수 있다.
//     2) enum으로 제공할 경우, 다른 사용자는 case 추가가 불가능하다.
#if false
struct VideoGame: Hashable {
  func start() {
    print("Video game - start")
  }
}

struct PCGame: Hashable {
  func start() {
    print("PC game - start")
  }
}

// enum은 case가 Equtable / Hashable을 만족할 경우, 자동으로 만족될 수 있다.
enum Game: Hashable {
  case video(VideoGame)
  case pc(PCGame)
}

var numberOfPlayers: [Game: Int] = [
  .pc(PCGame()): 10,
  .video(VideoGame()): 100,
]
#endif

// 2. 타입 소거(Boxing)를 이용하면, 문제를 해결 가능합니다.
//  => 컴파일 시간 프로토콜을 런타임 프로토콜 처럼 사용할 수 있는 방법을 제공할 수 있습니다.

protocol Game: Hashable {
  func start()
}

struct VideoGame: Game {
  func start() {
    print("Video game - start")
  }
}

struct PCGame: Game {
  func start() {
    print("PC game - start")
  }
}

// Game의 프로토콜의 구현체의 역활을 담당합니다.
//  Hashable - 직접 구현해야 하는 이유
//   : AnyGame은 직접 동작을 수행하는 것이 아니라, 자신이 참조하는 구체적인 타입에 대한 동작을 호출해야 합니다.

// 프로토콜의 역활을 대신하는 객체
struct AnyGame: Game {
  private let _start: () -> Void
  private let _hashable: AnyHashable

  func start() {
    _start()
  }

  init<T: Game>(_ game: T) {
    _start = game.start // 메소드를 연결한다.
    _hashable = AnyHashable(game)
  }

  func hash(into hasher: inout Hasher) {
    _hashable.hash(into: &hasher)
  }

  static func == (lhs: AnyGame, rhs: AnyGame) -> Bool {
    return lhs._hashable == rhs._hashable
  }
}

var numberOfPlayers: [AnyGame: Int] = [
  AnyGame(VideoGame()): 100,
  AnyGame(PCGame()): 42,
]

// ----
protocol Shape {
  associatedtype T

  func draw()
}

struct Rect: Shape {
  typealias T = String

  func draw() {
    print("Draw")
  }
}

struct AnyShape: Shape {
  func draw() {
    _draw()
  }

  typealias T = Void

  let _draw: () -> Void

  init<S: Shape>(_ shape: S) {
    _draw = shape.draw
  }
}

let p = AnyShape(Rect())
p.draw()

// ----
