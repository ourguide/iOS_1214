// https://github.com/ourguide/iOS_1214

import Foundation

// 1. Swift 특징
// 1) 고성능
// 2) 함수형 프로그래밍
// 3) 프로토콜 지향 프로그래밍 - POP
// 4) 강력한 컴타일 타임 언어

// 2. Swift 단점
// 1) 모듈 호환성
//   - 최신 스위프트의 버전이 나오면 이전 버전과 호환성이 떨어집니다.
// 2) 엄격한 타입 체크
//   - 다른 언어에 비해 엄격하다.
// 3) 프로토콜 난해

// Equtable
// - PAT(Protocol Associated Type): 프로토콜 연관 타입
#if false
func areAllEqual(value: Equatable, values: [Equatable]) -> Bool {
}
#endif

protocol Shape {
}

// protocol에 기본 구현을 제공하는 방법
extension Shape {
  func draw() {
    print("Shape draw")
  }
}

struct Rect : Shape {
  func draw() {
    print("Rect draw")
  }
}

// 정적 바인딩 - 컴파일러가 변수의 타입을 기반으로 함수를 호출하는 것
let rect: Rect = Rect()
rect.draw()          // Rect draw

let rect2: Shape = rect
rect2.draw()        // Shape draw


// 4) 동시성 지원 X
//   - GCD / RxSwift

// 5) Apple 플랫폼 종속성
//   - 스위프트는 리눅스 기반에서도 이용할 수 있지만, 지원하는 패키지의 개수가 많이 부족하다.

// 6) 컴파일 시간
//   - LLVM 기반 컴파일러를 이용함으로써, 정적 분석 등의 유용한 기능을 제공하지만
//     컴파일 프로세스의 시간이 오래 걸린다.
