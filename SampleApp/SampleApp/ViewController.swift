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
  
  // 1. 동기 버전
  @IBAction func onLoad(_ sender: UIButton) {
    let data = try! Data(contentsOf: IMAGE_URL)
    
    if let image = UIImage(data: data) {
      imageView.image = image
    }
  }
  
  
}
