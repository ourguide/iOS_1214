
import Foundation

// interface
protocol Shape {
  // func draw()
}

// 아래 코드 때문에 정적 바인딩이 아닙니다.
//  - 약속된 draw 메소드에 대한 기본 구현을 제공합니다.
extension Shape {
  func draw() {
    print("Shape draw")
  }
}

struct Rect: Shape {
  func draw() {
    print("Rect draw")
  }
}

struct Circle: Shape {
  func draw() {
    print("Circle draw")
  }
}

let shapes: [Shape] = [
  Rect(),
  Circle()
]

for shape in shapes {
  shape.draw()
}

// ----------
protocol Plant {
  // func grow()
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

// func grow<P: Plant>(_ plant: P) {
//  plant.grow()
// }

Oak().grow()
CherryTree().grow()
KiwiPlant().grow()
