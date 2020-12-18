
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
  
  // Subject
  let email = BehaviorSubject<String>(value: "xxxxx")
  
  @IBOutlet var bottomMargin: NSLayoutConstraint!
  
  // let email = PublishSubject<String>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    // Publish  => email.onNext("xx") 이 호출되기 전까지, 동작하지 않는다.
    // Behavior => 초기값이 존재하기 떄문에, 최신 값 이벤트를 수신한다.
    // email
    //  .subscribe(onNext: { text in
    //  })
    //  .disposed(by: disposeBag)
    
    emailField.rx.text
      .compactMap { $0 }
//      .subscribe(onNext: { _ in
//         self.email.onNext(emailText)
//      })
      .bind(to: email)
      .disposed(by: disposeBag)
    
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
    
    // Soft Keyboard Notification
    #if false
    keyboardHeight()
      .subscribe(onNext: { height in
        self.bottomMargin.constant = height
      })
      .disposed(by: disposeBag)
    #endif
    
    keyboardHeight()
      .bind(to: bottomMargin.rx.constant)
      .disposed(by: disposeBag)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
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
  
  func keyboardHeight() -> Observable<CGFloat> {
    Observable
      .from([
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
          .map { notification -> CGFloat in
            
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
              
          },
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
          .map { _ -> CGFloat in
            0
          }
      ])
      .merge()
  }
}
