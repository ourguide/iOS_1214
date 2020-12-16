
import Foundation

// 어떤 함수가 호출될지 정확하게 파악하는 것이 중요합니다.

protocol Plant {
  func grow()
}

extension Plant {
  func grow() {
    print("Plant - grow()")
  }
}

protocol Tree: Plant {}

extension Tree {
  func grow() {
    print("Tree - grow()")
  }
}

struct Oak: Tree {
  func grow() {
    print("Oak - grow()")
  }
}

struct CherryTree: Tree {}
struct KiwiPlant: Plant {}

//        Plant - KiwiPlant
//          |
//         Tree - Oak / CherryTree

func grow<P: Plant>(_ plant: P) {
  plant.grow()
}

grow(Oak())
grow(CherryTree())
grow(KiwiPlant())
