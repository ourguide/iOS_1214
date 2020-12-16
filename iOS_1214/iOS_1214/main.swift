
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
  // Shadowing
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

grow(Oak())          // Oak().grow()        : Oak grow
grow(CherryTree())   // CherryTree.graw()   : Tree grow
grow(KiwiPlant())    //                     : Plant grow

// 정적 바인딩 - 컴파일러가 타입을 통해 어떤 메소드를 호출할지 결정한다.
