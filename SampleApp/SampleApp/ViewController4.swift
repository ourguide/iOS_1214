
import RxCocoa
import RxSwift
import UIKit

class ViewController4: UIViewController {
  @IBOutlet var emailField: UITextField!
  @IBOutlet var passwordField: UITextField!

  @IBOutlet var loginButton: UIButton!
  @IBOutlet var imageView: UIImageView!

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
}

// iOP App
// - MVC
//   View    Controller     Model

//  문제점
// 1. View / Controller => UIKit에 의존성이 있습니다.
//                      : 단위 테스트 작성이 어렵습니다.

// 2. Controller의 역활이 크다.
//     => 거대한 클래스의 문제가 발생한다.

// - MVVM + Data Binding(RxCocoa / RxSwift)
//   : View에 대한 변경과, 이벤트 처리 => ViewModel
//  View        ->   UIKit
//  ViewModel   ->   UIKit에 의존성을 가지면 안됩니다.
//  Model
