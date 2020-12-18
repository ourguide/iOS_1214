
import RxCocoa
import RxSwift
import UIKit
// 1. email valid 체크
// 2. password valid 체크
// 3. email / password가 valid 한지에 따라서, 로그인 버튼이 활성화가 변경되어야 한다.

// 4. email이 valid 하지 않으면, imageView에 경고 이미지가 나타나야 한다.

class ViewController3: UIViewController {
  @IBOutlet var emailField: UITextField!
  @IBOutlet var passwordField: UITextField!

  @IBOutlet var loginButton: UIButton!
  @IBOutlet var imageView: UIImageView!
  
  let disposeBag = DisposeBag()
  
  // UIKit- rx
  //     : UI 부분을 업데이트 하거나, UI를 변경 하는 목적으로 사용된다.
  //     -  Main 스레드에서 동작해야 한다.
  //     -  오류 처리가 필요 없는 경우가 많다.
  
  //      => Driver(Observable인데, MainThread에서 동작하고, 오류가 발생하지 않는다)
  //       - subscribe(onNext: )  => drive(onNext: )
  //       - bind(to: )           => drive()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let emailIsValid = emailField.rx.text
      .asDriver()
      .map { email -> Bool in
        guard let email = email, email.count > 5, email.contains("@") else {
          return false
        }
        
        return true
      }
    
    let passwordIsValid = passwordField.rx.text
      .asDriver()
      .map { password -> Bool in
        guard let password = password, password.count > 3 else {
          return false
        }
        
        return true
      }
    
    Driver.combineLatest(emailIsValid, passwordIsValid)
      .map { $0 && $1 }
      .drive(loginButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    emailIsValid
      .map { !$0 }
      .drive(imageView.rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  #if false
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let emailIsValid = emailField.rx.text
      .catchAndReturn(nil)
      .observe(on: MainScheduler.instance)
      .map { email -> Bool in
        guard let email = email, email.count > 5, email.contains("@") else {
          return false
        }
        
        return true
      }
    
    let passwordIsValid = passwordField.rx.text
      .catchAndReturn(nil)
      .observe(on: MainScheduler.instance)
      .map { password -> Bool in
        guard let password = password, password.count > 3 else {
          return false
        }
        
        return true
      }
    
    Observable.combineLatest(emailIsValid, passwordIsValid)
      .observe(on: MainScheduler.instance)
      .map { $0 && $1 }
      .bind(to: loginButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    emailIsValid
      .observe(on: MainScheduler.instance)
      .map {
        !$0
      }
      .bind(to: imageView.rx.isHidden)
      .disposed(by: disposeBag)
    
    #if false
    Observable.combineLatest(emailIsValid, passwordIsValid)
      .map {
        $0 && $1
      }
      .subscribe(onNext: { [loginButton] isEnabled in
        loginButton?.isEnabled = isEnabled
      })
      .disposed(by: disposeBag)
    #endif
    
    #if false
    Observable.combineLatest(emailIsValid, passwordIsValid)
      .subscribe(onNext: { [loginButton] emailIsValid, passwordIsValid in
        loginButton?.isEnabled = emailIsValid && passwordIsValid
      })
      .disposed(by: disposeBag)
    #endif
  }
  #endif
}
