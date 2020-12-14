
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
  var url: String

  // 속성이 처음 접근되는 시점에 한번만 수행되도록 하고 싶다면, lazy 속성을 이용하면 됩니다.
  //  => 지연 초기화
  //  => 함수 호출을 지정해야 합니다.
  lazy var image: UIImage = {
    print("Download image from \(url)")
    sleep(2)

    return UIImage(url: url)
  }()

  lazy var image2: UIImage = loadImageFromUrl()

  // 메소드를 통해서 지연 속성을 초기화하는 것도 가능합니다.
  private func loadImageFromUrl() -> UIImage {
    print("Download image from \(url)")
    sleep(2)

    return UIImage(url: url)
  }
}

//  => 저장형 프로퍼티(Stored Property)이기 때문에, 값을 변경하는 동작을 수행하기 위해서 var로 지정되어야 합니다.
var image = Image(url: "https://a.com/1.jpg")
print("Image 생성")

for _ in 0 ..< 5 {
  print(image.image2)
}
