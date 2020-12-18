
import RxCocoa
import RxSwift
import UIKit

class ViewController4: UIViewController {
  @IBOutlet var emailField: UITextField!
  @IBOutlet var passwordField: UITextField!

  @IBOutlet var loginButton: UIButton!
  @IBOutlet var imageView: UIImageView!

  @IBOutlet var bottomMargin: NSLayoutConstraint!

  var viewModel = SignInViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    // View -> ViewModel  bind
    emailField.rx.text
      .compactMap { $0 }
      .bind(to: viewModel.email)
      .disposed(by: viewModel.disposeBag)

    #if false
    emailField.rx.text
      .compactMap { $0 }
      .subscribe(onNext: { text in
        // self.viewModel.email.onNext(text)  // - Subject
        self.viewModel.email.accept(text) // - Relay
      })
      .disposed(by: viewModel.disposeBag)
    #endif

    passwordField.rx.text
      .compactMap { $0 }
      .bind(to: viewModel.password)
      .disposed(by: viewModel.disposeBag)

    loginButton.rx.tap
      .flatMap(viewModel.login)
      .subscribe(onNext: { user in
        print(user)
      })
      .disposed(by: viewModel.disposeBag)

    // ViewModel -> View
    //  - asDriver
    //      bind(to:) -> drive()
    viewModel.loginButtonEnabled
      .asDriver(onErrorJustReturn: false)
      .drive(loginButton.rx.isEnabled)
      .disposed(by: viewModel.disposeBag)

    viewModel.isValidEmail
      .map { $0 }
      .bind(to: imageView.rx.isHidden)
      .disposed(by: viewModel.disposeBag)

    viewModel.keyboardHeight
      .bind(to: bottomMargin.rx.constant)
      .disposed(by: viewModel.disposeBag)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

#if false
class ViewController4: UIViewController {
  @IBOutlet var emailField: UITextField!
  @IBOutlet var passwordField: UITextField!

  @IBOutlet var loginButton: UIButton!
  @IBOutlet var imageView: UIImageView!

  @IBOutlet var bottomMargin: NSLayoutConstraint!

  var viewModel = SignInViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    // View -> ViewModel  bind
    emailField.rx.text
      .compactMap { $0 }
      .bind(to: viewModel.email)
      .disposed(by: viewModel.disposeBag)

    passwordField.rx.text
      .compactMap { $0 }
      .bind(to: viewModel.password)
      .disposed(by: viewModel.disposeBag)

    loginButton.rx.tap
      .flatMap(viewModel.login)
      .subscribe(onNext: { user in
        print(user)
      })
      .disposed(by: viewModel.disposeBag)

    // ViewModel -> View
    viewModel.loginButtonEnabled
      .bind(to: loginButton.rx.isEnabled)
      .disposed(by: viewModel.disposeBag)

    viewModel.isValidEmail
      .map { $0 }
      .bind(to: imageView.rx.isHidden)
      .disposed(by: viewModel.disposeBag)

    viewModel.keyboardHeight
      .bind(to: bottomMargin.rx.constant)
      .disposed(by: viewModel.disposeBag)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}
#endif

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
