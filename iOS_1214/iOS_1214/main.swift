
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

enum Game: Hashable {
  case video(VideoGame)
  case pc(PCGame)
}

var numberOfPlayers: [Game: Int] = [
  .pc(PCGame()): 10,
  .video(VideoGame()): 100,
]
