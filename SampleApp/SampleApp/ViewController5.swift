
import RxCocoa
import RxSwift
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

struct ViewModel {
  let disposeBag = DisposeBag()

  let searchName = BehaviorSubject<String>(value: "")

  let userName = BehaviorSubject<String>(value: "")
  let userType = BehaviorSubject<String>(value: "")

  let user = PublishSubject<User>()
  let avatarImage = PublishSubject<UIImage>()

  // searchName이 비어있지 않으면
  lazy var searchButtonEnabled = {
    searchName.map { (name: String) -> Bool in
      !name.isEmpty
    }
  }()

  init() {
    // User가 변경되면 UIImage 업데이트
    user
      .compactMap { (user: User) -> URL? in
        URL(string: user.avatarUrl)
      }
      .flatMapLatest(getData(url:))
      .compactMap { (data: Data) -> UIImage? in
        UIImage(data: data)
      }
      .bind(to: avatarImage)
      .disposed(by: disposeBag)

    // User가 변경되면 userName / userType 업데이트
    user
      .subscribe(onNext: { [self] user in
        userName.onNext(user.name)
        userType.onNext(user.type)
      })
      .disposed(by: disposeBag)
  }

  func getUser() -> Observable<User> {
    searchName
      .filter { login in
        !login.isEmpty
      }
      .compactMap { (login: String) -> URL? in
        URL(string: "https://api.github.com/users/\(login)")
      }
      .flatMapLatest(getData(url:))
      .compactMap { (data: Data) -> User? in
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try? decoder.decode(User.self, from: data)
      }
  }

  func getData(url: URL) -> Observable<Data> {
    return Observable.create { observer -> Disposable in
      let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
          observer.onError(error)
          return
        }

        guard let data = data else {
          observer.onError(NSError(domain: "Invalid Data(null)", code: 0, userInfo: [:]))
          return
        }

        observer.onNext(data)
        observer.onCompleted()
      }

      task.resume()

      return Disposables.create {
        task.cancel()
      }
    }
  }
}

// 1. searchNameField를 1글자 이상 입력하고,
//    Enter를 누르거나 검색 버튼을 통해 검색 결과를 얻어올 수 있다.
// 2. user.avatarUrl -> avatarImage
//         name      -> nameLabel
//         type      -> typeLabel
//         login     -> navigationItem.title

// 3. follower 버튼은 user가 존재할 경우, 활성화된다.
// 4. 검색 결과가 없는 경우 이미지는 기본 이미지로 변경된다.
//     navigationItem.title도 Error!
