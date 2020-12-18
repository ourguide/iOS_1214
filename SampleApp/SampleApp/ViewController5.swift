
import UIKit

class ViewController5: UIViewController {
  @IBOutlet var searchNameField: UITextField!
  @IBOutlet var avatarImageView: UIImageView!
  @IBOutlet var searchButton: UIButton!

  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var typeLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
}

// 1. searchNameField를 1글자 이상 입력하고,
//    Enter를 누르거나 검색 버튼을 통해 검색 결과를 얻어올 수 있다.
// 2. user.avatarUrl -> avatarImage
//         name      -> nameLabel
//         type      -> typeLabel
//         login     -> navigationItem.title

// 3. follower 버튼은 user가 존재할 경우, 활성화된다.
