import UIKit

let IMAGE_URL = URL(string: "https://picsum.photos/500/500")!

class ViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var timeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
      self.timeLabel.text = "\(Date().timeIntervalSince1970)"
    }
  }
  
  // 2. 비동기 - GCD
  
  @IBAction func onLoad(_ sender: UIButton) {
   
    
    DispatchQueue.global().async {
      let data = try! Data(contentsOf: IMAGE_URL)
      
      if let image = UIImage(data: data) {
        
        DispatchQueue.main.async {
          self.imageView.image = image
        }
        
      }
    }
  
    
  }
  

  // 1. 동기 버전
  //  문제점: UI 스레드에서 오래 걸리는 작업을 수행할 경우,
  //        UI의 업데이트가 멈추는 문제가 발생합니다.
  //  해결방법
  //    - 비동기로 처리해야 합니다.
  //      비동기: 별도의 백그라운드 스레드를 통해 문제를 해결해야 합니다.
  //           GCD library
  #if false
  @IBAction func onLoad(_ sender: UIButton) {
    let data = try! Data(contentsOf: IMAGE_URL)
    
    if let image = UIImage(data: data) {
      imageView.image = image
    }
  }
  #endif
}
