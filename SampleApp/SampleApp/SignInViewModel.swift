
import Foundation
import RxSwift     // RxCocoa를 사용하면 안됩니다.


struct SignInViewModel {
  let email = BehaviorSubject<String>(value: "")
  let password = BehaviorSubject<String>(value: "")
 
  let disposeBag = DisposeBag()
  
  lazy var isValidEmail: Observable<Bool> = {
    email.map { (value: String) -> Bool in
      return value.count > 3
    }
  }()
  
  lazy var isValidPassword: Observable<Bool> = {
    password.map { (value: String) -> Bool in
      return value.count > 3
    }
  }()
  
  lazy var loginButtonEnabled: Observable<Bool> = {
    Observable.combineLatest(isValidEmail, isValidPassword)
      .map { $0 && $1 }
  }()
}

