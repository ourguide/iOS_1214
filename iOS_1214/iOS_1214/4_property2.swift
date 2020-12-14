
import Foundation

struct UIImage {
  let url: String
}

#if false
struct Image {
  var url: String

  // 계산이 오래 걸리는 작업에 대해서는, 계산형 프로퍼티는 적합하지 않다.
  var image: UIImage {
    print("Download image from \(url)")
    sleep(2)

    return UIImage(url: url)
  }
}
#endif

struct Image {
  // 4) 주의: lazy 블록에서 의존하는 속성은 불변으로 만드는 것이 좋다.
  let url: String

  // 속성이 처음 접근되는 시점에 한번만 수행되도록 하고 싶다면, lazy 속성을 이용하면 됩니다.
  //  => 지연 초기화
  //  => 함수 호출을 지정해야 합니다.

  private(set) lazy var image: UIImage = {
    print("Download image from \(url)")
    sleep(2)

    return UIImage(url: url)
  }()

  // lazy var image2: UIImage = loadImageFromUrl()

  // 메소드를 통해서 지연 속성을 초기화하는 것도 가능합니다.
  private func loadImageFromUrl() -> UIImage {
    print("Download image from \(url)")
    sleep(2)

    return UIImage(url: url)
  }

  init(url: String) {
    self.url = url
  }
}

// 주의사항
//  1) 저장형 프로퍼티(Stored Property)이기 때문에, 값을 변경하는 동작을 수행하기 위해서 var로 지정되어야 합니다.
var image = Image(url: "https://a.com/1.jpg")

//  2) 초기화 메소드를 통해 초기화될 경우 의도하지 않은 동작이 발생할 수 있습니다.
//   해결방법: 사용자 정의 초기화 메소드를 추가하는 것이 좋습니다.
// var image = Image(url: "https://a.com/1.jpg", image: UIImage(url: ""))

// 3) 세터를 통해서 image가 외부에서 변경될 경우, 초기화 블록이 제대로 수행되지 않습니다.
//   해결방법: 외부에서 접근이 불가능하도록 해주는 것이 좋습니다.
// image.image = UIImage(url: "")

print("Image 생성")

for _ in 0 ..< 5 {
  print(image.image)
}

// image.url = "https://a.com/2.jpg"
print(image.image)
