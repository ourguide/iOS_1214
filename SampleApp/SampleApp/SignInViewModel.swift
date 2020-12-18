
import Foundation
import RxSwift // RxCocoa를 사용하면 안됩니다.

// Model과 상호작용한다.
struct SignInViewModel {
  let email = BehaviorSubject<String>(value: "")
  let password = BehaviorSubject<String>(value: "")
 
  let disposeBag = DisposeBag()
  
  lazy var isValidEmail: Observable<Bool> = {
    email.map { (value: String) -> Bool in
      value.count > 3
    }
  }()
  
  lazy var isValidPassword: Observable<Bool> = {
    password.map { (value: String) -> Bool in
      value.count > 3
    }
  }()
  
  lazy var loginButtonEnabled: Observable<Bool> = {
    Observable.combineLatest(isValidEmail, isValidPassword)
      .map { $0 && $1 }
  }()
  
  func login() -> Observable<User> {
    return Observable.combineLatest(email, password)
      .take(1)
      .flatMap { (_, _) -> Observable<User> in
        Observable.just(User(login: "", avatarUrl: "", type: "Test"))
      }
  }
  
  lazy var keyboardHeight: Observable<CGFloat> = {
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
  }()
}
